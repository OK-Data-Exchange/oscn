module Importers
  module Pd
    class Offense < Base
      def initialize(offense_json)
        @offense_json = offense_json
        @dates = {
          mdate: offense_json['modifiedDate'] ? offense_json['modifiedDate'].split('T')[0] : ' ',
          mtime: offense_json['modifiedTime'] ? offense_json['modifiedTime'].split('T')[-1] : ' ',
          edate: offense_json['enteredDate'] ? offense_json['enteredDate'].split('T')[0] : ' ',
          etime: offense_json['enteredTime'] ? offense_json['enteredTime'].split('T')[-1] : ' ',
          ddate: offense_json['dispositionDate'] ? offense_json['dispositionDate'].split('T')[0] : ' ',
          dtime: offense_json['dispositionTime'] ? offense_json['dispositionTime'].split('T')[-1] : ' ',
          cdate: offense_json['courtDate'] ? offense_json['courtDate'].split('T')[0] : ' ',
          ctime: offense_json['courtTime'] ? offense_json['courtTime'].split('T')[-1] : ' '
        }

        super()
      end

      def to_datetime(date, time)
        "#{date.split('T')[0]}T#{time.split('T')[-1]}" if date && time
      end

      # todo: combine this is in base and clean
      def self.iterate_aws(start = 0, finish = 100)
        failed_booking_ids = []
        (start...finish).each do |i|
          digits = i.to_s.rjust(2, '0') # ensure 2 digits, i.e., 2 is "02"
          puts "Processing for #{digits}"
          jsons = list_files('Offenses', false, "#{digits}")
          bar = ProgressBar.new(jsons.count)
          jsons.each_with_index do |json, i|
            begin
              perform(json)
            rescue StandardError
              if failed_booking_ids.count > 100 && i / failed_booking_ids.count < 3
                raise StandardError, "Error parsing pdf: #{json['message']}"
              end

              failed_booking_ids << json['bookingId'] if json
            end
            bar.increment!
          end
        end
        puts 'Complete. Failed bookings were: '
        puts failed_booking_ids
      end

      def self.perform(offense_json)
        new(offense_json).perform
      end

      def perform
        booking = ::Pd::Booking.find_or_initialize_by(id: @offense_json['bookingId'])

        booking.save!

        offense = ::Pd::Offense.find_or_initialize_by(id: @offense_json['offenseSeq'])
        offense.assign_attributes(get_attributes(@offense_json, @dates))
        offense.booking = booking
        offense.save!
        @offense_json['offenseMinutes'].each do |minute|
          min_date = minute['minuteDate'].try(:split, 'T').try(:first) || ' '
          min_time = minute['minuteTime'].try(:split, 'T').try(:first) || ' '
          datetime = "#{min_date}T#{min_time}"
          offense_minute = ::Pd::OffenseMinute.find_or_initialize_by(offense: offense, minute_date: datetime,
                                                                     minute: minute['minute'],
                                                                     minute_by: minute['minuteBy'],
                                                                     judge: minute['judge'],
                                                                     next_proceeding: minute['nextProceding'])
          offense_minute.save!
        end
      end

      def get_attributes(offense_json, dates)
        {
          booking_id: offense_json['bookingId'], docket_id: offense_json['docketId'],
          offense_seq: offense_json['offenseSeq'], case_number: offense_json['caseNumber'],
          offense_code: offense_json['offenseCode'], offense_special_code: offense_json['offenseSpecialCode'],
          offense_description: offense_json['offenseDescription'], offense_category: offense_json['offenseCategory'],
          court: offense_json['court'], judge: offense_json['judge'],
          court_date: "#{dates['cdate']}T#{dates['ctime']}", bond_amount: offense_json['bondAmount'],
          bond_type: offense_json['bondType'], jail_term: offense_json['jailTerm'],
          jail_sentence_term_type: offense_json['jailSentenceTermType'],
          jail_conviction_date: offense_json['jailConvictionDate'],
          jail_start_date: offense_json['jailStartDate'], form41_filed: offense_json['form41Filed'],
          docsentence_term: offense_json['docsentenceTerm'], docsentence_term_type: offense_json['docsentenceTermType'],
          docsentence_date: offense_json['docsentenceDate'], docnotified: offense_json['docnotified'],
          sentence_agent: offense_json['sentenceAgent'], narative: offense_json['narative'],
          disposition: offense_json['disposition'], disposition_date: "#{dates['ddate']}T#{dates['dtime']}",
          entered_date: "#{dates['edate']}T#{dates['etime']}", entered_by: offense_json['enteredBy'],
          modified_date: "#{dates['mdate']}T#{dates['mtime']}", modified_by: offense_json['modifiedBy']
        }
      end
    end
  end
end
