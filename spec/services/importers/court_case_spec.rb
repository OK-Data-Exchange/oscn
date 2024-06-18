require 'rails_helper'

RSpec.describe Importers::CourtCase do
  describe '#perform' do
    let!(:party_type1)  { create(:party_type, :defendant) }
    let!(:party_type2)  { create(:party_type, :plaintiff) }
    it 'saves data for a case' do
      # Create a case with html from fixture
      county = create(:county, name: 'Tulsa')
      create(:judge, name: 'CF Docket E')
      court_case = create(:court_case, county_id: county.id, case_number: 'CF-2018-1016')
      html = File.read('spec/fixtures/new_event_example.html')
      create(:case_html, court_case: court_case, html: html)

      # Run importer
      described_class.new(county.id, 'CF-2018-1016').perform
      court_case = CourtCase.find(court_case.id) # Pull updated object
      expect(court_case.parties.count).to eq 3
      expect(court_case.counts.count).to eq 4
      expect(court_case.current_judge.name).to eq 'CF Docket E'
      expect(court_case.events.count).to eq 13
      expect(court_case.counsels.count).to eq 1
      expect(court_case.docket_events.count).to eq 113
    end

    xit 'saves data for a case with the kp vs ocis structure (present in smaller counties)' do
      # Create a case with html from fixture
      county = create(:county, name: 'Wagoner')
      create(:judge, name: 'KIRKLEY, DOUGLAS')
      court_case = create(:court_case, county_id: county.id, case_number: 'CF-2022-00029')
      html = File.read('spec/fixtures/kp-example.html')
      create(:case_html, court_case: court_case, html: html)

      # Run importer
      described_class.new(county.id, 'CF-2022-00029').perform
      court_case = CourtCase.find(court_case.id) # Pull updated object
      expect(court_case.parties.count).not_to be 0
      expect(court_case.counts.count).not_to be 0
      expect(court_case.events.count).not_to be 0
      expect(court_case.counsels.count).not_to be 0
      expect(court_case.docket_events.count).not_to be 0
    end

    it 'saves party with text only for a case' do
      # Create a case with html from fixture
      county = create(:county, name: 'oklahoma')

      create(:judge, name: 'Collins, April')
      court_case = create(:court_case, county_id: county.id, case_number: 'CS-2022-1020')
      html = File.read('spec/fixtures/oscn_id_less.html')
      create(:case_html, court_case: court_case, html: html)

      # Run importer

      described_class.new(county.id, 'CS-2022-1020').perform
      court_case = CourtCase.find(court_case.id) # Pull updated object

      expect(court_case.parties.count).to eq 3

      expect(court_case.current_judge.name).to eq 'Collins, April'
      expect(court_case.id).to eq CourtCase.joins(:parties).where("parties.full_name = 'Jackson, Erin'").first.id
      expect(court_case.id).to eq CourtCase.joins(:parties).where("parties.full_name = 'Jackson, John Jr.'").first.id
      expect(court_case.id).to eq CourtCase.joins(:parties).where("parties.full_name = 'Bank Of Oklahoma Na'").first.id
    end
  end
end
