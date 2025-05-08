require 'rails_helper'

RSpec.describe Pd::Offense, type: :model do
  describe 'associations' do
    it { should have_many(:offense_minutes).dependent(:destroy) }
    it { should belong_to(:booking).class_name('Pd::Booking') }
  end

  describe 'validations' do
    it { should validate_presence_of(:offense_seq) }
  end
end
