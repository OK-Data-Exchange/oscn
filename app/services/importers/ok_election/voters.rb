module Importers
  module OkElection
    class Voters
      attr_reader :bucket, :precincts

      def initialize
        @bucket = Bucket.new
        @precincts = ::OkElection::Precinct.all.pluck(:code, :id).to_h
      end

      def self.perform
        new.perform
      end

      def perform
        objects = bucket.list_objects('ok_election/voter_registration')
        objects['contents'].each_with_index do |object, _i|
          puts "Processing #{object['key']}"
          file = bucket.get_object(object['key'])
          next unless file.content_type == 'text/csv'

          voters = CSV.parse(file.body.read, headers: true, encoding: 'Windows-1252:UTF-8', liberal_parsing: true)
          bar = ProgressBar.new(voters.count)
          voter_data = []

          voters.each do |voter|
            bar.increment!
            voter_data << voter_data(voter)
          end
          voter_data.each_slice(10_000) do |slice|
            ::OkElection::Voter.upsert_all(slice, unique_by: :voter_id)
          end
        end
      end

      # def perform
      #   objects = bucket.list_objects('ok_election/voter_registration')
      #   objects['contents'].each_with_index do |object, _i|
      #     puts "Processing #{object['key']}"
      #     next unless object['key'].include?('CTY41_vr')
      #     file = bucket.get_object(object['key'])
      #     next unless file.content_type == 'text/csv'

      #     # Read and clean CSV content
      #     content = file.body.read

      #     # Store cleaned voter data
      #     voter_data = []

      #     # Process CSV with liberal parsing
      #     voters = CSV.parse(content, headers: true, encoding: 'Windows-1252:UTF-8', liberal_parsing: true)

      #     bar = ProgressBar.new(voters.count)

      #     voters.each do |voter|
      #       bar.increment!

      #       # Ensure date fields are quoted correctly
      #       # voter.each do |key, value|
      #       #   if value && value.match(/^\d{1,2}\/\d{1,2}\/\d{4}$/)  # Matches MM/DD/YYYY format
      #       #     voter[key] = value
      #       #   end
      #       # end

      #       begin
      #         voter_data << voter_data(voter)
      #       rescue => e
      #         puts "Error processing voter: #{e.message}"
      #         ap voter
      #         binding.pry
      #       end

      #       # Batch insert voters into the database
      #       voter_data.each_slice(10_000) do |slice|
      #         ::OkElection::Voter.upsert_all(slice, unique_by: :voter_id)
      #       end
      #     end
      #   end
      # end

      private

      def parse_date(date, _voter)
        return nil if date.blank?

        begin
          Date.strptime(date, '%m/%d/%Y')
        rescue StandardError => _e
          puts "Error parsing date: #{date}"
        end
      end

      def voter_data(voter)
        precinct_id = precincts[voter['Precinct'].to_i]
        registration_date = parse_date(voter['OriginalRegistration'], voter)
        date_of_birth = parse_date(voter['DateOfBirth'], voter)

        {
          voter_id: voter['VoterID'],
          precinct_id: precinct_id,
          last_name: voter['LastName'],
          first_name: voter['FirstName'],
          middle_name: voter['MiddleName'],
          suffix: voter['Suffix'],
          political_affiliation: ::OkElection::Voter.political_affiliations[voter['PolitalAff']],
          status: voter['Status'] == 'A' ? 'active' : 'inactive',
          street_number: voter['StreetNum'],
          street_direction: voter['StreetDir'],
          street_name: voter['StreetName'],
          street_type: voter['StreetType'],
          building_number: voter['BldgNum'],
          city: voter['City'],
          zip_code: voter['Zip'],
          date_of_birth: date_of_birth,
          original_registration: registration_date
        }
      end
    end
  end
end
