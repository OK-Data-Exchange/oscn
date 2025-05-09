class County < ApplicationRecord
  OKLAHOMA = 'Oklahoma'
  TULSA = 'Tulsa'

  has_many :court_cases, dependent: :destroy
  has_many :case_not_founds, dependent: :destroy
  has_many :census_datas, class_name: 'Census::Data', as: :area, dependent: :destroy
  belongs_to :district_attorney, optional: true
  has_one :doc_sentencing_county, class_name: 'Doc::SentencingCounty'

  validates :name, :fips_code, presence: true

  enum rms: {
    ocis: 'OCIS',
    kp: 'KP'
  }

  def self.name_id_mapping
    pluck(:name, :id).to_h
  end
end
