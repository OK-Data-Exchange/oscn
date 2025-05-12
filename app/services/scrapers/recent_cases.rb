module Scrapers
  # Returns cases on the docket for the past X days
  class RecentCases
    attr_reader :days_ago, :case_types, :case_changes, :court_cases, :county, :days_forward
    attr_accessor :recent_cases

    def initialize(county, days_ago, days_forward)
      @case_changes = OscnScraper::Parsers::CaseChanges
      @county = county
      @court_cases = CourtCase.for_county_name(county).pluck(:case_number, :oscn_id).to_h
      @case_types = CaseType.active
      @recent_cases = []
      @days_ago = days_ago
      @days_forward = days_forward
    end

    def self.perform(county, days_ago: 7, days_forward: 7)
      new(county, days_ago, days_forward).perform
    end

    def perform
      date_range.each do |date|
        puts "Pulling case changes for #{date.to_date}"
        fetch_docket_for_date(date)
      end
      recent_cases.flatten
    end

    def fetch_docket_for_date(date)
      case_types.each do |case_type_oscn_id|
        case_numbers = scrape_recent_cases(date, case_type_oscn_id)
        recent_cases << case_numbers
      end
      recent_cases
    end

    def scrape_recent_cases(date, case_type_oscn_id)
      data = fetch_data(county, date, case_type_oscn_id)

      data.each do |link|
        Importers::NewCourtCase.new(link).perform if court_cases[link.text].nil?
      end
      return if data.empty?

      data.map(&:text)
    end

    def fetch_data(county, date, case_type_oscn_id)
      scraper = OscnScraper::Requestor::Report.new({
                                                     county: county,
                                                     case_type_id: case_type_oscn_id,
                                                     date: date
                                                   })
      request = scraper.events_scheduled
      case_changes.new(Nokogiri::HTML.parse(request.body)).parse
    end

    def date_range
      (Date.current - days_ago..Date.current + days_forward).to_a
    end
  end
end
