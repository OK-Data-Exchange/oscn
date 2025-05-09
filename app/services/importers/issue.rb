module Importers
  # Imports Issue data from parsed json
  class Issue
    attr_accessor :court_case, :logs, :count_codes
    attr_reader :issues_json

    def initialize(issues_json, court_case, logs)
      @issues_json = issues_json
      @court_case = court_case
      @count_codes = CountCode.pluck(:code, :id).to_h
      @logs = logs
    end

    def self.perform(issues_json, court_case, logs)
      new(issues_json, court_case, logs).perform
    end

    def perform
      issues_json.each do |issue_data|
        i = save_issue(issue_data)
        ::Importers::IssueParty.perform(i, issue_data[:parties], logs) if i.present? && issue_data[:parties].present?
      end
    end

    def find_issue(issue_data)
      ::Issue.find_or_initialize_by(
        court_case_id: court_case.id,
        number: issue_data[:number]
      )
    end

    def save_issue(issue_data)
      i = find_issue(issue_data)
      i.assign_attributes(issue_attributes(issue_data))
      begin
        i if i.save!
      rescue StandardError
        logs.create_log('issues', "#{court_case.case_number}: Error creating issue", issue_data)
      end
    end

    def issue_attributes(issue_data)
      code_id = find_or_create_count_code(issue_data[:issue_code]&.squish)

      {
        name: issue_data[:issue_name],
        filed_by: issue_data[:filed_by],
        filed_on: issue_data[:filed_on] == 'Not Available' ? nil : issue_data[:filed_on],
        count_code_id: code_id
      }
    end

    def find_or_create_count_code(code)
      count_code_id = count_codes[code]
      return nil if code.nil?

      return count_code_id if count_code_id

      new_count_code = CountCode.create(code: code)
      @count_codes = CountCode.pluck(:code, :id).to_h
      new_count_code.id
    end
  end
end
