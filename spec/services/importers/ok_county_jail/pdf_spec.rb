require 'rails_helper'

RSpec.describe Importers::OkCountyJail::Pdf do
  describe '#perform' do
    before do
      link = 'https://www.okcountydc.net/_files/ugd/413d25_a5e2f3d02e394e909a16bc4cd3c84a5a.pdf'
      described_class.perform(link)
    end

    it 'saves a page with multiple offenses' do
      multiple_offense_booking_number = '140088715'
      booking = OkCountyJail::Booking.find_by(booking_number: multiple_offense_booking_number)
      expect(booking.offenses.count).to be 6
    end

    it 'saves a page with a multiline offense' do
      multiple_offense_booking_number = '140088728'
      booking = OkCountyJail::Booking.find_by(booking_number: multiple_offense_booking_number)
      expect(booking.offenses.count).to be 2
      mutiline_description = 'ASSAULT AND BATTERY UPON DEPARTMENT OF CORRECTIONS EMPLOYEE'
      expect(booking.offenses.map(&:description)).to include mutiline_description
    end
  end
end
