module Scrapers
  # Updates html for cases that have been on the docket in the past week or cases without html (new cases)
  class HighPriority
    attr_accessor :days_ago, :county, :days_forward, :include_event_updates

    def initialize(county_name, days_ago: 7, days_forward: 7, include_event_updates: true)
      @days_ago = days_ago
      @county = County.find_by(name: county_name)
      @days_forward = days_forward
      @include_event_updates = include_event_updates
    end

    def self.perform(county_name, days_ago: 7, days_forward: 7, include_event_updates: true)
      new(county_name, days_ago: days_ago, days_forward: days_forward, include_event_updates: include_event_updates)
        .perform
    end

    def perform
      cases = fetch_case_list
      bar = ProgressBar.new(cases.count)
      puts "#{cases.count} are high priority for update for #{county.name} county"
      cases.each do |case_number|
        begin
          court_case = ::CourtCase.find_by!(county_id: @county.id, case_number: case_number)
        rescue ActiveRecord::RecordNotFound => e
          Raygun.track_exception(e, custom_data: { error_type: 'CaseNotFound' })
          next
        else
          next if court_case.enqueued

          court_case.update(enqueued: true)
          CourtCaseWorker
            .set(queue: :high)
            .perform_async(@county.id, case_number, true)
        end
        bar.increment!
      end
    end

    def fetch_case_list
      missing_html_cases = CourtCase.for_county_name(county.name).without_html.pluck(:case_number)
      return missing_html_cases unless include_event_updates

      recent_cases = Scrapers::RecentCases.perform(county.name, days_ago: days_ago, days_forward: days_forward)
      (recent_cases + missing_html_cases).flatten.uniq.compact
    end
  end
end
