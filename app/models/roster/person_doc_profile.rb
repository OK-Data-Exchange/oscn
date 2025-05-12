class Roster::PersonDocProfile < ApplicationRecord
  self.table_name = :roster_people_merged_doc_numbers
  belongs_to :doc_profile, class_name: '::Doc::Profile', foreign_key: :doc_number, primary_key: :doc_number
end
