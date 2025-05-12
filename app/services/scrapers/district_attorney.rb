module Scrapers
  class DistrictAttorney
    attr_reader :district_json

    def initialize(district_json)
      @district_attorneys = []
      @district_json = district_json
    end

    def self.perform
      new(district_json).perform
    end

    def perform
      district_json.each do |dist|
        da = ::DistrictAttorney.find_or_initialize_by(name: dist[:district_attorney])
        da.number = dist[:district]
        da.save!
        dist[:counties].each do |county|
          current_county = County.find_by! name: county
          current_county.district_attorney_id = da.id
          current_county.save!
        end
      end
    end
  end
end
