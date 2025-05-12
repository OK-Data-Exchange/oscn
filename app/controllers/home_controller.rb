class HomeController < ApplicationController

  # before_action :require_login, :except => [:login, :passwordless_sent]

  def login
    render "home/login"
  end

  def passwordless_sent
    @user_email = params[:user][:email]
  end

  def index
    @users = User.all
    @per_page = 100

    @params = params
    unless params[:query]
      @last_case_scrape = CourtCase.all.maximum(:updated_at)
      @last_tulsa_blotter_scrape = TulsaBlotter::Arrest.all.maximum(:updated_at)
      # @last_jailnet_scrape = Pd::Booking.where(arrest_date: ..Time.now).maximum(:arrest_date)
      @last_doc_scrape = Doc::Status.all.maximum(:date)
      @merge_by_name = false
      @reports = {
        oscn_counties_all: oscn_counties_all,
        oscn_counties_cf: oscn_counties_all('CF'),
        oscn_counties_cm: oscn_counties_all('CM')
      }
      return render
    end

    @merge_by_name = params[:query][:merge_by_name]

    @first_name = params[:query][:first_name]
    @last_name = params[:query][:last_name]
    @case_number = params[:query][:case_number]
    @inmate_id = params[:query][:inmate_id]
    @doc_number = params[:query][:doc_number]

    @party_ids = params[:party_ids]
    @dlms = params[:dlms]
    @doc_numbers = params[:doc_numbers]

    @roster_people = if @merge_by_name
                       person_details_query
                     else
                       person_query
                     end

    render
  end

  def person_query
    person_query = Roster::Person
                     .includes(
                       pd_inmates: :offenses,
                       parties: [:addresses, :court_cases],
                       doc_profiles: :statuses
                     )
                     .where.not(parties: { birth_month: nil }) # keep out police party records etc (todo: find a better way)
                     .group(:ids, :party_ids, :dlms, :doc_numbers)

    if @first_name.present? || @last_name.present?
      person_query = person_query.left_outer_joins(
        :pd_inmates,
        :parties,
        :doc_profiles,
        :tulsa_blotter_inmates
      )
      party_query = person_query
      party_query = party_query.where('lower(parties.first_name) = ?', @first_name.downcase) if @first_name.present?
      party_query = party_query.where('lower(parties.last_name) = ?', @last_name.downcase) if @last_name.present?

      pd_query = person_query
      if @first_name.present?
        pd_query = pd_query.where('lower(pd_bookings.inmate_name) LIKE ?',
                                  "#{@first_name.downcase} %")
      end
      if @last_name.present?
        pd_query = pd_query.where('lower(pd_bookings.inmate_name) LIKE ?',
                                  "% #{@last_name.downcase}%")
      end

      doc_query = person_query
      doc_query = doc_query.where('lower(doc_profiles.first_name) = ?', @first_name.downcase) if @first_name.present?
      doc_query = doc_query.where('lower(doc_profiles.last_name) = ?', @last_name.downcase) if @last_name.present?

      tulsa_query = person_query
      tulsa_query = tulsa_query.where('lower(tulsa_blotter_arrests.first) = ?', @first_name.downcase) if @first_name.present?
      tulsa_query = tulsa_query.where('lower(tulsa_blotter_arrests.last) = ?', @last_name.downcase) if @last_name.present?

      person_query = party_query.or(pd_query).or(doc_query).or(tulsa_query)
    end

    if @case_number.present?
      person_query = person_query.left_outer_joins(
        parties: [:court_cases]
      )
      person_query = person_query.where("court_cases.case_number ilike #{clean_case_number_sql}",
                                        @case_number, @case_number, @case_number, @case_number, @case_number,
                                        @case_number, @case_number, @case_number, @case_number
      )
    end

    if @doc_number.present?
      person_query = person_query.left_outer_joins(
        :doc_profiles
      )
      person_query = person_query.where('doc_profiles.doc_number = ?', @doc_number) if @doc_number.present?
    end

    if @inmate_id.present?
      person_query = person_query.left_outer_joins(
        :pd_inmates,
        :tulsa_blotter_inmates
      )
      jailnet_query = person_query.where('lower(pd_bookings.jailnet_inmate_id) = ?',
                                         @inmate_id.downcase)

      tulsa_query = person_query.where('lower(tulsa_blotter_arrests.dlm) = ?',
                                       @inmate_id.downcase)
      person_query = jailnet_query.or(tulsa_query)
    end

    person_query = person_query.order(doc_numbers: :desc, dlms: :desc).limit(@per_page)
    # person_query = person_query.order('court_cases.filed_on desc, pd_bookings.arrest_date desc')

    puts person_query.to_sql
    person_query
  end

  def clean_case_number_sql
    <<-SQL
      CASE
        WHEN ((?)::text ~ '^[A-Za-z]{2}-[0-9]{4}-[0-9]{1,}'::text) THEN (
                "substring"((?)::text, 1, 8) ||
                regexp_replace("substring"((?)::text, 9), '^0+'::text, ''::text))
        WHEN ((?)::text ~ '^[A-Za-z]{2}-[0-9]{2}-[0-9]{1,}'::text) THEN (
                ((("substring"((?)::text, 1, 2) || '-'::text) ||
                  CASE
                      WHEN (("substring"((?)::text, 4, 2))::integer <= 40)
                          THEN ('20'::text || "substring"((?)::text, 4, 2))
                      ELSE ('19'::text || "substring"((?)::text, 4, 2))
                      END) || '-'::text) ||
                regexp_replace("substring"((?)::text, 7), '^0+'::text, ''::text))
        ELSE NULL::text
      END
    SQL
  end

  def person_details_query
    person_query = Roster::PersonDetail
                     .left_outer_joins(people: { parties: :court_cases })
                     .includes(
                       people: {
                         pd_inmates: :offenses,
                         parties: [:addresses, :court_cases],
                         doc_profiles: :statuses
                       }
                     )
                     .group(:id, :first_name, :last_name, :birth_month, :birth_year)

    if @first_name.present? || @last_name.present?
      person_query = person_query.where(first_name: @first_name.upcase) if @first_name.present?
      person_query = person_query.where(last_name: @last_name.upcase) if @last_name.present?
    end

    if @case_number.present?
      person_query = person_query.left_outer_joins(
        people: {
          parties: [:court_cases]
        }
      )
      person_query = person_query.where("court_cases.case_number ilike #{clean_case_number_sql}",
                                        @case_number, @case_number, @case_number, @case_number, @case_number,
                                        @case_number, @case_number, @case_number, @case_number
      )
    end

    if @doc_number.present?
      person_query = person_query.left_outer_joins(
        people: :doc_profiles
      )
      person_query = person_query.where('doc_profiles.doc_number = ?', @doc_number) if @doc_number.present?
    end

    if @inmate_id.present?
      person_query = person_query.left_outer_joins(
        people: [:pd_inmates, :tulsa_blotter_inmates]
      )
      jailnet_query = person_query.where('lower(pd_bookings.jailnet_inmate_id) = ?',
                                         @inmate_id.downcase)

      tulsa_query = person_query.where('lower(tulsa_blotter_arrests.dlm) = ?',
                                       @inmate_id.downcase)
      person_query = jailnet_query.or(tulsa_query)
    end

    person_query = person_query.limit(@per_page)
    person_query.order(:birth_year).order('birth_year, max(court_cases.filed_on) desc')
  end

  def person
    @roster_person = Roster::Person
                       .includes(
                         pd_inmates: :offenses,
                         parties: [:addresses, :court_cases],
                         doc_profiles: :statuses
                       ).by_any_id(params)
    @roster_person = @roster_person.first

    render 'roster/people/show'
  end

  def person_detail
    @roster_person = Roster::PersonDetail
                       .includes(
                         people: {
                           pd_inmates: :offenses,
                           parties: [:addresses, :court_cases],
                           doc_profiles: :statuses
                         }
                       ).find(params[:id])

    render 'roster/people/show'
  end

  def stats
    render
  end

  def edit
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to root_path, notice: 'User deleted.'
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      format.html do

        if @user.update(params.require(:user).permit :password, :password_confirmation)
          # success message
          flash[:success] = 'Password updated successfully'
          # redirect to index

          redirect_to root_path
        else
          # error message
          flash.now[:error] = 'Error: Password could not be updated'
          # render edit
        end
      end
    end
  end

  private

  def require_login
    unless current_user
      redirect_to new_user_session_path
    end
  end

  def oscn_counties_all(case_type = false)
    case_type_clause = "and case_types.abbreviation = '#{case_type}'" if case_type
    sql = <<-SQL
      select 
        c.name as county, 
        date_part('year', date_trunc('year', filed_on))::int as year, 
        count(*) as count from court_cases
        join case_types on court_cases.case_type_id = case_types.id
        join counties c on court_cases.county_id = c.id
                         where c.name in ('Wagoner',
                                          'Creek',
                                          'Rogers',
                                          'Osage',
                                          'Washington',
                                          'Ottawa',
                                          'Tulsa',
                                          'Oklahoma',
                                          'Delaware',
                                          'Muskogee')
        and filed_on is not null 
        and date_part('year', date_trunc('year', filed_on))::int >= 2010
        #{case_type_clause}
        group by c.name, date_trunc('year', filed_on)
        order by c.name, date_part('year', date_trunc('year', filed_on))::int
    SQL
    result = ActiveRecord::Base.connection.exec_query(sql).map(&:symbolize_keys)
    puts "case type is: #{case_type}"
    puts result
    result
  end
end
