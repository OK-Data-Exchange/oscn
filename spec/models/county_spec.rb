require 'rails_helper'

RSpec.describe County, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:fips_code) }
  end

  describe 'associations' do
    it { should have_many(:court_cases).dependent(:destroy) }
    it { should have_many(:case_not_founds).dependent(:destroy) }
    it { should have_many(:census_datas).dependent(:destroy) }
    it { should belong_to(:district_attorney).class_name('DistrictAttorney').optional }
    it { should define_enum_for(:rms) }
  end

  describe '#name_id_mapping' do
    it 'returns a hash of the name to id' do
      county = create(:county)
      mapping = County.name_id_mapping

      expect(mapping[county.name]).to eq county.id
    end
  end
end
