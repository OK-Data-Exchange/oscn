require 'rails_helper'

RSpec.describe Scrapers::DistrictAttorney do
  describe '#perform' do
    fixture_path = 'spec/fixtures/district_attorney.html'
    html = File.read(fixture_path)

    it 'saves  district attorney and hooks up counties' do
      counties = ['Beaver', 'Cimarron', 'Harper', 'Texas', 'Beckham', 'Custer', 'Ellis', 'Roger Mills', 'Washita',
                  'Greer', 'Harmon', 'Jackson', 'Kiowa', 'Tillman']

      counties.each do |name|
        create(:county, name: name)
      end

      parser = OscnScraper::Parsers::DistrictAttorney.new(html)
      parser.perform

      data = parser.district_attorneys
      test = described_class.new(data)
      test.perform

      test_attorney = DistrictAttorney.find_by! name: 'George Leach'
      county = County.find_by! name: 'Beaver'

      expect(county.district_attorney_id).to eq test_attorney.id
      expect(DistrictAttorney.all.size).to eq data.size
      expect(test_attorney.name).to eq data.first[:district_attorney]
    end
  end
end
