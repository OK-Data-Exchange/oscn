class Roster::PersonDlm < ApplicationRecord
  self.table_name = :roster_people_merged_dlms
  belongs_to :tulsa_blotter_inmate, class_name: 'TulsaBlotter::Arrest', foreign_key: :dlm, primary_key: :dlm
  belongs_to :pd_inmate, class_name: 'Pd::Booking', foreign_key: :dlm, primary_key: :jailnet_inmate_id
end
