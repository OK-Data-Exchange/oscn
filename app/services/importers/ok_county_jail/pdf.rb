require 'open-uri'

module Importers
  module OkCountyJail
    class Pdf < ApplicationService
      attr_reader :link

      def initialize(link)
        @link = link
        super()
      end

      def perform
        io = URI.parse(link).open
        reader = PDF::Reader.new(io)
        all_pages = []
        reader.pages.each do |page|
          all_pages << page_to_dict(page)
        end
        puts all_pages
      end

      def upsert(data); end

      def booking_data(lines)
        fields = field_map_from_sample.except(:offense_table)
        data = {}
        last_line = false
        shift = 0
        fields.each do |field, position|
          line = position[:line]
          if line != last_line
            last_line = line
            shift = 0
          end
          data[field], shift = get_value(lines, position, shift)
        end
        data[:offense_table] = offenses_data(lines)
        data
      end

      def offense_table_row_shift(lines, fields)
        actual_header_row = lines.index { |x| 'Arrest Code'.in?(x) }
        expected_header_row = (fields.values[0][:line] - 1)
        expected_header_row - actual_header_row
      end

      def offenses_data(lines)
        fields = field_map_from_sample[:offense_table]
        data = []
        row_count = 0
        character_shift = 0
        loop do
          row_data = {}
          line = fields.values[0][:line] - offense_table_row_shift(lines, fields) + row_count
          fields.each do |field, position|
            position[:line] = line
            begin
              row_data[field], character_shift = get_value(lines, position, character_shift)
            rescue StandardError
              # todo: fix error when offense description takes multiple lines
              binding.pry
            end
          end
          break if row_data.compact.empty?

          data << row_data
          row_count += 1
        end
        data
      end

      def page_to_dict(page)
        lines = page.text.split(/\n/)
        booking_data(lines)
      end

      def get_value(lines, position, shift)
        line = lines[position[:line]]
        return [nil, shift] unless line.present?

        value = field_value(line, position[:start], position[:end], shift)
        while has_gap(value)
          puts "Empty space detected. Trying shift for: #{value}"
          shift = gap_position(value) >= 2 ? shift + 1 : shift - 1
          value = field_value(line, position[:start], position[:end], shift)
        end
        [value, shift]
      end

      def gap_position(value)
        value.index(/[^:]\s\s/)
      end

      def has_gap(value)
        value.match(/[^:]\s\s/)
      end

      def field_value(line, start, end_position, shift)
        start_position = start - shift
        end_position = end_position.present? ? end_position - shift : nil
        line[start_position...end_position].strip
      end

      def field_map_from_sample
        return @field_map if @field_map

        link = 'https://www.okcountydc.net/_files/ugd/413d25_a5e2f3d02e394e909a16bc4cd3c84a5a.pdf'
        io = URI.parse(link).open
        reader = PDF::Reader.new(io)
        sample_text = reader.pages[1].text.split(/\n/)
        # Avoid PII in here. Partial data should suffice.
        @field_map = {
          offender_name: locate_in_sample(sample_text, 'AHBO', '- 9/20/19'),
          dob: locate_in_sample(sample_text, '9/20/19', '03/01'),
          booked_at: locate_in_sample(sample_text, '03/01', nil),
          height: locate_in_sample(sample_text, 'Hgt', 'Wgt'),
          weight: locate_in_sample(sample_text, 'Wgt', 'Brown Eyes'),
          eyes: locate_in_sample(sample_text, 'Brown Eyes', 'Brown Hair'),
          hair_color: locate_in_sample(sample_text, 'Brown Hair', 'Long Hair Length'),
          hair_length: locate_in_sample(sample_text, 'Long Hair Length', 'Light Skin Tone'),
          skin: locate_in_sample(sample_text, 'Light Skin Tone', nil),
          offense_table: {
            code: locate_in_sample(sample_text, '21.1283', 'CARRY OR POSSESS'),
            description: locate_in_sample(sample_text, 'CARRY OR POSSESS', 'TMP44916'),
            case_number: locate_in_sample(sample_text, 'TMP44916', 'TMP44916'),
            bond: locate_in_sample(sample_text, '3000.00', nil)
          }
        }
        @field_map
      end

      def locate_in_sample(lines, from_text, to_text)
        line_index = lines.find_index { |line| line.include? from_text }
        unless line_index
          raise StandardError, 'Text not found in sample. Check sample text or pass in a different value to locate.'
        end

        line = lines[line_index]
        {
          line: line_index,
          start: line.index(from_text),
          end: to_text ? line.index(to_text) : nil
        }
      end
    end
  end
end
