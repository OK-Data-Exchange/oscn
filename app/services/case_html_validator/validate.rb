module CaseHtmlValidator
  class CaseHtmlValidationError < StandardError
  end

  class Validate < ApplicationService
    attr_accessor :county, :case_number, :errors, :from_fixture, :case_path

    def initialize(county, case_number, from_fixture: false)
      @county = county
      @case_number = case_number
      @errors = []
      @from_fixture = from_fixture
      @parsed_data = false
      @case_path = "app/services/case_html_validator/expected/#{county}/#{case_number}"
      super()
    end

    def retrieve_html
      OscnScraper::Requestor::Case
        .new({ county: county, number: case_number })
        .fetch_case_by_number
    rescue StandardError => e
      @errors << {
        section: 'all',
        message: "Unable to fetch #{case_number} from oscn.net. Errror: #{e}"
      }
      raise CaseHtmlValidationError
    end

    def parse_html(case_html)
      parsed_html = Nokogiri::HTML(case_html)
      OscnScraper::Parsers::BaseParser.new(parsed_html).build_object
    rescue StandardError => e
      @errors << {
        section: 'all',
        message: "Unable to parse html for #{case_number}. Error: #{e}"
      }
      raise CaseHtmlValidationError
    end

    def parsed_data
      return @parsed_data if @parsed_data

      if from_fixture
        path = "#{@case_path}/current_case_fixture.html"
        case_html = File.read(path)
      else
        case_html = retrieve_html
      end
      @parsed_data = parse_html(case_html)
      @parsed_data
    end

    def perform
      begin
        validate
      rescue CaseHtmlValidationError
        return handle_error
      end
      if @errors.length.zero?
        puts "HTML for #{@case_number} in #{@county} county parsed successfully"
      else
        handle_error
      end
    end

    def validate
      validate_section(:parties)
      validate_section(:judge)
      validate_section(:attorneys)
      validate_section(:counts)
      validate_section(:issues)
      validate_section(:events)
      validate_section(:docket_events)
    end

    def validate_section(section)
      begin
        expected = JSON.parse(File.read("#{@case_path}/#{section}.json"))
      rescue NoMethodError
        expected = File.read(file_path)
      end
      actual = JSON.parse(parsed_data[section].to_json)
      differences = Hashdiff.diff(expected, actual, indifferent: true)
      return unless differences.present?

      @errors << {
        section: section,
        message: 'Parsed data for section did not match',
        differences: differences
      }
    end

    def handle_error
      puts 'did not pass'
      email_error
    end

    def email_error
      CaseHtmlErrorMailer.error_email(@county, @case_number, @errors).deliver_now
    end
  end
end
