# PersonDetail is a person but with records merged by name and birth month/year

class Roster::PersonDetail < ApplicationRecord
  self.table_name = 'roster_people_details_merged'
  self.primary_key = :id

  has_many :person_details_person, foreign_key: :roster_people_details_merged_id
  has_many :people, through: :person_details_person, foreign_key: :roster_people_details_merged_id

  def birth_date
    birth_dates = people.map(&:birth_date).compact
    birth_dates.each do |birth_date|
      return birth_date if birth_date.is_a?(Date)
    end
    birth_dates.first
  end

  def race
    people.map(&:race).compact.first
  end

  def height
    people.map(&:height).compact.first
  end

  def zip
    people.map(&:zip).compact.first
  end

  def current_facility
    people.map(&:current_facility).compact.first
  end

  def party
    people.map(&:party).compact.first
  end

  def pd_inmate
    people.map(&:pd_inmate).compact.first
  end

  def doc_profile
    people.map(&:doc_profile).compact.first
  end

  def tulsa_blotter_inmate
    people.map(&:tulsa_blotter_inmate).compact.first
  end

  def party_ids
    people.map(&:party_ids).flatten.compact
  end

  def dlms
    people.map(&:dlms).flatten.compact
  end

  def doc_numbers
    people.map(&:doc_numbers).flatten.compact
  end

  def readonly?
    true
  end

  def court_cases
    people.map(&:court_cases).flatten.sort_by(&:filed_on).reverse
  end

  def latest_case
    court_cases.max_by { |u| u.filed_on || DateTime.new(1700) }
  end

  def oldest_case
    court_cases.min_by { |u| u.filed_on || DateTime.new(1700) }
  end

  def tulsa_blotter_inmates
    people.map(&:tulsa_blotter_inmate).compact
  end

  def pd_inmates
    people.map(&:pd_inmate).compact
  end

  def doc_profiles
    people.map(&:doc_profile).compact
  end


  def booking_timeline
    return @booking_timeline if @booking_timeline
    pd_bookings = tulsa_blotter_inmates.map { |x| x.all_arrests }.flatten
    jailnet_bookings = pd_inmates.map { |x| x.all_bookings }.flatten
    doc_bookings = doc_profiles
                     .map { |x| x.statuses }
                     .flatten
                     .filter{ |x| x.booking_facility != 'INACTIVE' }

    timeline = (pd_bookings + jailnet_bookings + doc_bookings)
      .sort_by(&:booking_arrested_at)
      .uniq(&:booking_id)


    timeline_doc_merged = []
    timeline.each do |booking|
      if !timeline_doc_merged or
        !booking.is_a?(Doc::Status) or
        !timeline_doc_merged[-1].is_a?(Doc::Status) or
        timeline_doc_merged[-1].booking_facility != booking.booking_facility or
        timeline_doc_merged[-1].booking_released_at != booking.booking_arrested_at
        timeline_doc_merged << booking
      else
        timeline_doc_merged[-1].inferred_released_at == booking.booking_released_at
      end
    end
    @booking_timeline = timeline_doc_merged.reverse
  end

  def booking_timeline_by_case_number(case_number)
    booking_timeline
      .filter do |booking|
        booking.booking_offenses.any? do |offense|
          offense.offense_clean_case_number == case_number
        end
      end
  end

  def url
    "/person_detail?id=#{id}"
  end
end
