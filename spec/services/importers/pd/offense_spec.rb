require 'rails_helper'

RSpec.describe Importers::Pd::Offense do
  describe '#perform' do
    it 'imports the data' do
      file_path = 'spec/fixtures/pd/offenses.json'
      test_data =  File.read(file_path)
      test_json =  JSON.parse(test_data)
      Importers::Pd::Offense.perform(test_json)
      expect(::Pd::Offense.all.size).to eq(1)
      expect(::Pd::OffenseMinute.all.size).to eq(18)
    end
  end
end
