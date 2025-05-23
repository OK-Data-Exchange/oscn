require 'rails_helper'

RSpec.describe Importers::Ok2Explore::ScrapeJob do
  describe '#perform' do
    before do
      Rails.application.load_seed
      scraped_records = [{
        'lastName' => 'UNDER',
        'firstName' => 'DAVID',
        'middleName' => 'J',
        'deathDate' => '2019-12-25T00:00:00',
        'deathDay' => 25,
        'deathMonth' => 12,
        'deathYear' => 2019,
        'deathCounty' => 'Comanche',
        'gender' => 'M'
      }]
      allow_any_instance_of(::Ok2explore::Scraper).to receive(:perform).and_return(scraped_records)
    end
    let!(:scrape_job) { create(:ok2_explore_scrape_job, year: 2019, month: 12, first_name: 'd', last_name: 'u') }

    it 'creates death records and updates scrape_job' do
      described_class.perform(scrape_job)
      expect(Ok2Explore::Death.count).to be >= 1
      scrape_job.is_success = true
      scrape_job.is_too_many_records = false
    end

    context 'when too many records retrieved' do
      before do
        allow_any_instance_of(::Ok2explore::Scraper)
          .to receive(:perform).and_raise(::Ok2explore::Errors::TooManyResults)
      end
      it 'fans out records and sets as too many records' do
        described_class.perform(scrape_job)
        scrape_job.is_too_many_records = true
        expect(Ok2Explore::ScrapeJob.find_by(last_name: 'ua')).not_to be_nil
        expect(Ok2Explore::ScrapeJob.find_by(last_name: 'uz')).not_to be_nil
      end
    end
  end
end
