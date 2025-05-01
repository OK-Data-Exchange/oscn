module Importers
  # Imports events into database from a case
  class Event
    attr_accessor :events_json, :court_case, :logs, :party_matcher, :judges, :event_types

    def initialize(events_json, court_case, logs)
      @court_case = court_case
      @events_json = events_json
      @logs = logs
      @judges = ::Judge.all.to_h { |j| [j.first_last, j.id] }
      @event_types = ::EventType.pluck(:code, :id).to_h
      @party_matcher = Matchers::Party.new(court_case)
    end

    def self.perform(events_json, court_case, logs)
      new(events_json, court_case, logs).perform
    end

    def perform
      events_json.each do |event_data|
        save_events(event_data)
      rescue StandardError => e
        Raygun.track_exception(e,
                               custom_data: { error_type: 'Data Error', data_content: event_data,
                                              case_number: court_case.case_number })
      end
    end

    def save_events(event_data)
      e = find_event(event_data)
      e.docket = event_data[:docket]
      e.judge_id = judges[event_data[:docket]]
      e.event_name = event_data[:event_type]
      e.event_type_id = event_types[event_data[:event_code]]

      begin
        e.save!
      rescue StandardError
        logs.create_log('events', "#{court_case.case_number}: error when creating the event", event_data)
      end
    end

    def find_event(event_data)
      # TODO: Check that the event_at field is importing correctly
      party_id = party_matcher.party_id_from_name(event_data[:party_name].squish)
      ::Event
        .find_or_initialize_by({
                                 court_case_id: court_case.id,
                                 event_at: event_data[:date],
                                 event_name: event_data[:event_type],
                                 party_id: party_id
                               })
    end
  end
end
