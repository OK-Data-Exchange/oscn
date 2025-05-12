module Importers
  module Pd
    class Base < ApplicationService

      @@all_files_list = {}

      def self.all_files(type)
        return @@all_files_list[type] if @@all_files_list[type]
        puts "fetching file list from AWS"

        continue = true
        @@all_files_list[type] = []
        next_continuation_token = nil
        while continue
          returned_files = aws_client.list_objects_v2(
            bucket: ENV.fetch('JAILNET_BUCKET_NAME', 'jailnet'),
            prefix: type,
            continuation_token: next_continuation_token
          )
          @@all_files_list[type] += returned_files.data[:contents]
          next_continuation_token = returned_files.data[:next_continuation_token]
          continue = false unless next_continuation_token
        end
        @@all_files_list[type]
      end

      def self.from_aws_after(after_date)
        type = name.split('::').last.pluralize
        list_files(type, after_date).each do |json|
          perform(json)
        end
      end

      def self.list_files(type, after_date=false, name_suffix=false)
        puts "retrieving files after #{after_date} and/or with suffix #{name_suffix}"

        files = all_files(type)
        files = files.filter { |x| x[:last_modified] > after_date } if after_date
        files = files.filter { |x| x[:key].remove('.json').ends_with? name_suffix } if name_suffix != false
        file_keys = files.map { |x| x[:key] }
        puts "#{file_keys.count} files found (#{all_files(type).count} total returned)"

        bar = ProgressBar.new(file_keys.count)
        jsons = []
        file_keys.each do |file_key|
          response = aws_client.get_object(bucket: ENV.fetch('JAILNET_BUCKET_NAME', 'jailnet'), key: file_key)
          jsons << JSON.load(response.body)
          bar.increment!
        end
        puts "done getting data"
        puts "first record:"
        puts jsons.first
        puts "count:"
        puts jsons.count
        jsons
      end

      def self.aws_client
        credentials = Aws::Credentials.new(ENV.fetch('JAILNET_AWS_ACCESS_KEY_ID'),
                                           ENV.fetch('JAILNET_AWS_SECRET_ACCESS_KEY'))
        Aws.config.update(
          region: ENV.fetch('JAILNET_AWS_REGION', 'us-east-1'),
          credentials: credentials
        )
        Aws::S3::Client.new
      end
    end
  end
end
