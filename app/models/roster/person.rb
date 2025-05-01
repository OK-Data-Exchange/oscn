class Roster::Person < ApplicationRecord
  self.table_name = 'roster_people_merged'
  self.primary_key = :ids

  # technically these are has_many but this is a syntactic shortcut for through table
  # has_and_belongs_to_many :parties, foreign_key: :party_id, :join_table => :roster_people_merged_parties
  # has_and_belongs_to_many :pd_inmates, class_name: 'Pd::Booking', foreign_key: :dlm, primary_key: :roster_people_merged_id, :join_table => :roster_people_merged_dlms
  # has_and_belongs_to_many :tulsa_blotter_inmates, class_name: 'TulsaBlotter::Arrest', foreign_key: :dlm, primary_key: :roster_people_merged_id, :join_table => :roster_people_merged_dlms
  has_many :person_doc_profile, foreign_key: :roster_people_merged_id, primary_key: :ids
  has_many :doc_profiles, through: :person_doc_profile
  has_many :person_party, foreign_key: :roster_people_merged_id, primary_key: :ids
  has_many :parties, through: :person_party
  has_many :person_dlms, foreign_key: :roster_people_merged_id, primary_key: :ids
  has_many :tulsa_blotter_inmates, through: :person_dlms
  has_many :pd_inmates, through: :person_dlms

  # A person can be associated with multiple IDs
  # But an ID can only be associated with one person
  # So we can use any of the IDs provided to look ip the person
  # This allows us to provide more stable permalinks where new ids may be added
  # ids_to_find expected as arrays of "party_ids", "dlms", "doc_numbers"
  scope :by_any_id, lambda { |ids_to_find|
    id_field_options = ["party_ids", "dlms", "doc_numbers"]
    id_field = id_field_options.find{|x| ids_to_find[x].present? }
    id_to_find = ids_to_find[id_field]&.first
    query_string = "'#{id_to_find}' = any(#{id_field})"
    where(query_string)
  }

  def first_name
    party&.first_name || tulsa_blotter_inmate&.first || pd_inmate&.first_name || doc_profile&.first_name
  end

  def last_name
    party&.last_name || tulsa_blotter_inmate&.last || pd_inmate&.last_name || doc_profile&.last_name
  end

  def birth_date
    pd_inmate&.birth_date&.to_date || doc_profile&.birth_date || party&.birth_date_string
  end

  def race
    pd_inmate&.race || doc_profile&.race
  end

  def height
    pd_inmate&.height_string || doc_profile&.height_string
  end

  def zip
    (party&.most_recent_address)&.zip || pd_inmate&.zip_code
  end

  def current_facility
    pd_inmate&.current_facility || doc_profile&.current_facility
  end

  def party
    parties.first
  end

  def pd_inmate
    pd_inmates.first
  end

  def doc_profile
    doc_profiles.first
  end

  def tulsa_blotter_inmate
    tulsa_blotter_inmates.first
  end

  def readonly?
    true
  end

  def court_cases
    # https://stackoverflow.com/a/35539062/796437
    parties.map(&:court_cases).flatten.sort_by{ |a| [a.filed_on ? 1 : 0, a.filed_on] }.reverse
  end

  def latest_case
    court_cases.max_by { |u| u.filed_on || DateTime.new(1700) }
  end

  def oldest_case
    court_cases.min_by { |u| u.filed_on || DateTime.new(1700) }
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
    party_ids_params = party_ids.map{ |x| "party_ids[]=#{x}" }
    dlms_params = dlms.map{ |x| "dlms[]=#{x}" }
    doc_numbers_params = doc_numbers.map{ |x| "doc_numbers[]=#{x}" }
    query_string = (party_ids_params + dlms_params + doc_numbers_params).join('&')
    "/person?#{query_string}"
  end
end
