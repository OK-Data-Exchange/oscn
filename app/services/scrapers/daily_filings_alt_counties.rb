module Scrapers

  # Some counties aren't available on the daily filings report.
  # This is an alternative system.
  # Should only be used as a backup for smaller counties,
  # as it is limited to retrieving up to 500 per day currently.

  class DailyFilingsAltCounties
    attr_accessor :date, :county, :case_number, :case_types

    def initialize(county_name, date)
      @date = date
      @county_name = county_name
      @case_number = case_number
      @case_types = CaseType.oscn_id_mapping
      @county = County.find_by(name: @county_name)
    end

    def self.perform(county, case_number)
      new(county, case_number).perform
    end

    def perform
      parsed_html = scrape_html
      data = parse_html(parsed_html)

      Raygun.track_exception("Hit limit on cases for #{county_name} on #{date}") if data.count == 500
      data.each do |row|
        case_type_id = find_case_type(row)
        next if case_type_id.blank?

        court_case = create_court_case(row, case_type_id)

        court_case.update(enqueued: true)
        CourtCaseWorker
          .set(queue: :medium)
          .perform_async(county.id, court_case.case_number, true)
      end
    end

    private

    def scrape_html
      html = OscnScraper::Requestor::Search.fetch_cases(
        {
          db: @county_name,
          FiledDateL: date,
          FiledDateH: date
        }
      )
      Nokogiri::HTML(html.body)
    end

    def parse_html(html)
      OscnScraper::Parsers::Search.parse(html, county.name.downcase)
    end

    def find_case_type(row)
      case_type = row[:case_number].split('-').first
      case_types[case_type]
    end

    def create_court_case(row, case_type_id)
      c = ::CourtCase.find_or_initialize_by(oscn_id: row[:oscn_id], county_id: county.id)
      c.case_type_id = case_type_id
      c.case_number = row[:case_number]
      c.save!
      c
    end
  end
end
