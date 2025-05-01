require 'json'

class TulsaCityWorker
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  sidekiq_options retry: 5, queue: :high
  sidekiq_throttle_as :tulsa_city
  def self.perform(record_id, active)
    new.perform(record_id, active)
  end

  def perform(incident_record_id, active)
    inmate = perform_inmate(incident_record_id)

    inmate = inmate.transform_values(&:strip)
    tulsa_inmate = save_inmate(inmate, incident_record_id, active)

    offense_json = perform_offense(tulsa_inmate.incident_record_id)
    offense_json.each do |offense|
      offense = offense.transform_values(&:strip)
      save_offense(offense, tulsa_inmate)
    end
  end

  def save_inmate(inmate_json, incident_record_id, active)
    inmate = ::TulsaCity::Inmate.find_or_create_by(incident_record_id: incident_record_id)
    inmate.inmate_id = inmate_json['inmateId']
    inmate.first_name = inmate_json['firstName']
    inmate.middle_name = inmate_json['middleName']
    inmate.last_name = inmate_json['lastName']
    inmate.height = inmate_json['height']
    inmate.weight = inmate_json['weight']
    inmate.hair_color = inmate_json['hairColor']
    inmate.eye_color = inmate_json['eyeColor']
    inmate.race = inmate_json['race']
    inmate.gender = inmate_json['gender']
    inmate.arrest_date = assign_datetime(inmate_json['arrestDate'], inmate_json['inmateId'])
    inmate.arresting_officer = inmate_json['arrestingOfficer']
    inmate.arresting_agency = inmate_json['arrestingAgency']
    inmate.booking_date_time = assign_datetime(inmate_json['bookingDateTime'], inmate_json['inmateId'])
    inmate.court_date = assign_datetime(inmate_json['CourtDate'], inmate_json['inmateId'])
    inmate.released_date_time = assign_datetime(inmate_json['releasedDateTime'], inmate_json['inmateId'])
    inmate.court_division = inmate_json['courtDivision']
    inmate.incident_record_id = incident_record_id
    inmate.dob =  assign_date(inmate_json['DOB'], inmate_json['inmateId'])
    inmate.active = active
    inmate.save!
    inmate
  end

  def assign_datetime(datetime, inmate_number)
    if datetime.nil?
      nil
    else
      begin
        DateTime.strptime(datetime, '%m/%d/%Y %H:%M:%S')
      rescue StandardError
        begin
          DateTime.strptime(datetime, '%m/%d/%Y %H:%M')
        rescue StandardError
          puts "Invalid Date on Offense or Inmate, Inmate number: #{inmate_number} , Date:#{datetime}"
          nil
        end
      end
    end
  end

  def assign_date(date, inmate_number)
    if date.nil?
      nil
    else
      begin
        Date.strptime(date, '%m/%d/%Y')
      rescue StandardError
        puts "Invalid Date on Offense or Inmate, Inmate number: #{inmate_number} , Date:#{date}"
        nil
      end
    end
  end

  def save_offense(offense_json, inmate)
    offense = ::TulsaCity::Offense.find_or_create_by(docket_id: offense_json['docketId'], inmate_id: inmate.id)
    offense.bond = offense_json['bond']
    offense.court_date = assign_datetime(offense_json['courtDate'], inmate.inmate_id)
    offense.case_number = offense_json['caseNumber']
    offense.court_division = offense_json['courtDivision']
    offense.hold = offense_json['hold']
    offense.docket_id = offense_json['docketId']
    offense.title = offense_json['title']
    offense.section = offense_json['section']
    offense.paragraph = offense_json['paragraph']
    offense.crime = offense_json['crime']

    offense.save!
    offense
  end

  def perform_offense(dataid)
    headers = { 'Content-Type' => 'application/json', 'charset' => 'UTF-8', 'Accept' => '*/*' }
    offense_url = "https://www.cityoftulsa.org/apps/InmateInformationCenter/AjaxReference/Incident.aspx/ServiceReference?dataId=#{dataid}"

    offenses = HTTParty.post(offense_url, headers: headers)

    JSON.parse(offenses['d']['ReturnCode'])
  end

  def perform_inmate(dataid)
    headers = { 'Content-Type' => 'application/json', 'charset' => 'UTF-8', 'Accept' => '*/*' }
    inmate_url = "https://www.cityoftulsa.org/apps/InmateInformationCenter/AjaxReference/InmateInfo.aspx/ServiceReference?dataId=#{dataid}"

    inmate = HTTParty.post(inmate_url, headers: headers)

    JSON.parse(inmate['d']['ReturnCode'])
  end
end
