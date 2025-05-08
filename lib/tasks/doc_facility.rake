require 'open-uri'
require 'csv'

namespace :doc do
  desc 'fill out doc_facility table and link records to status and profile'
  task doc_facilities: [:environment] do
    csv_path = 'lib/Prison.Facilities-Table.1.csv'
    prison_names = []
    facil = Doc::Status.distinct.pluck(:facility)
    facil_prof = Doc::Profile.distinct.pluck(:facility)
    status_profile_facil = (facil + facil_prof).uniq

    CSV.foreach(csv_path, headers: true) do |row|
      name = row[0]

      prison_names << name
    end

    status_profile_facil.each_with_index do |fac, _index|
      prison = prison_names.include? fac

      next if fac.blank? || fac.nil?

      facility = DocFacility.find_or_initialize_by(name: fac, is_prison: prison)
      facility.save!

      status = Doc::Status.where(facility: fac)

      status.update_all(doc_facility_id: facility.id)

      profile = Doc::Profile.where(facility: fac)

      profile.update_all(doc_facility_id: facility.id)
    end
  end
end
