require 'rails_helper'

RSpec.describe Importers::OkCountyJail::Pdf do
  describe '#perform' do
    before do
      link = 'https://www.okcountydc.net/_files/ugd/413d25_a5e2f3d02e394e909a16bc4cd3c84a5a.pdf'
      described_class.perform(link)
    end

    it 'saves a page with multiple offenses' do
      link = 'https://www.okcountydc.net/_files/ugd/413d25_a5e2f3d02e394e909a16bc4cd3c84a5a.pdf'
      described_class.perform(link)
      multiple_offense_booking_number = '140088715'
      booking = OkCountyJail::Booking.find_by(booking_number: multiple_offense_booking_number)
      expect(booking.offenses.count).to be 6
    end
  end
end
