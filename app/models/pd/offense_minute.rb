class Pd::OffenseMinute < ApplicationRecord
  belongs_to :offense, class_name: 'Pd::Offense'
end
