require 'rails_helper'

RSpec.describe Issue, type: :model do
  describe 'associations' do
    it { should belong_to(:count_code).optional }
    it { should belong_to(:court_case) }
    it { should have_many(:issue_parties).dependent(:destroy) }
  end
end
