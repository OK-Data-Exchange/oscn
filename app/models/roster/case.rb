class Roster::Case < ApplicationRecord
  belongs_to :court_case
  # TODO: fix pd_inmate association (might want to create its own table?)
  belongs_to :pd_offense, class_name: 'Pd::Offense', foreign_key: :pd_offense_id
  belongs_to :pd_offense, class_name: 'Pd::Booking', foreign_key: :pd_booking_id
  belongs_to :doc_profile, class_name: 'Doc::Profile', foreign_key: :doc_number
  belongs_to :doc_sentence, class_name: 'Doc::Sentence', foreign_key: :doc_sentence_id
end