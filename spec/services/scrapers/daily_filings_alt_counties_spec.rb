require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe Scrapers::DailyFilingsAltCounties do
  describe '#perform' do
    it 'creates a new case' do
      VCR.use_cassette 'daily_filings_alt_counties' do
        Sidekiq::Testing.inline! do
          Scrapers::DailyFilingsAltCounties.perform('Muskogee', '2010-01-04')
          expect(CourtCase.first).not_to eq(nil)
          expect(CourtCase.first.html).not_to eq(nil)
        end
      end
    end

    it 'scrapes case but not html when equeue is false' do
      VCR.use_cassette 'daily_filings_alt_counties' do
        Sidekiq::Testing.inline! do
          Scrapers::DailyFilingsAltCounties.perform('Muskogee', '2010-01-04', enqueue: false)
          expect(CourtCase.first).not_to eq(nil)
          expect(CourtCase.first.html).to eq(nil)
        end
      end
    end
  end
end
