require 'rails_helper'

RSpec.describe Pd::OffenseMinute, type: :model do
  it { should belong_to(:offense).class_name('Pd::Offense') }
end
