# Scraper
module Scrapers
  # Handles which cases to update first
  class Case
    def self.perform
      new.perform
    end

    def perform
      # TODO: Capture results and send via email or slack message
      Scrapers::WarrantsView.perform
      counties.each do |county|
        if OscnScraper::Requestor::DAILING_FILINGS_COUNTIES.include? county
          Scrapers::NewCases.perform(county, days_ago: days_ago)
          Scrapers::HighPriority.perform(county, days_ago: days_ago, days_forward: days_forward)
        else
          date_range = (DateTime.now.to_date - days_ago...DateTime.now.to_date)
          date_range.each do |date|
            Scrapers::DailyFilingsAltCounties.perform(county, date, enqueue: false)
          end
          Scrapers::HighPriority.perform(county, include_event_updates: false)
        end
      end

      Scrapers::MediumPriority.perform
      Scrapers::LowPriority.perform
    end

    def counties
      ENV['COUNTIES'].split(',')
    end

    def days_ago
      ENV.fetch('DAYS_AGO', 7).to_i
    end

    def days_forward
      ENV.fetch('DAYS_FORWARD', 7).to_i
    end
  end
end
