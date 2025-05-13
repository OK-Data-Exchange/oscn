require 'zip'

module Scrapers
  module Doc
    class QuarterlyData < ApplicationService
      def initialize(dir)
        @dir = dir
        super()
      end

      def perform
        scrape_to_s3
        validate_schema_from_readme
      end

      private

      def scrape_to_s3
        input = HTTParty.get(download_link).body
        Zip::InputStream.open(StringIO.new(input)) do |io|
          while (entry = io.get_next_entry)
            content = io.read
            filename = entry.name
            Bucket.new.put_object("doc/#{@dir}/#{filename}", content)
          end
        end
      end

      def validate_schema_from_readme
        expected_readme = File.read('app/services/scrapers/doc/supported_version_ReadMe.txt')
        actual_readme = Bucket.new.get_object("doc/#{@dir}/readme.txt").body.string
        return true if actual_readme.split.join == expected_readme.split.join

        # Using a diff tool here to compare values did not seem to work due to strange whitespace differences
        raise StandardError, 'supported_version_ReadMe.txt does not match actual readme. ' \
                             'Please check for schema changes using a diff tool and update code ' \
                             'and supported_version_ReadMe.txt accordingly.'
      end

      def download_link
        domain = 'https://oklahoma.gov'
        request = HTTParty.get("#{domain}/doc/media-relations.html")
        dom = Nokogiri::HTML(request.body)
        path = dom.css("a:contains('download here')").first['href']
        "#{domain}#{path}"
      end
    end
  end
end
