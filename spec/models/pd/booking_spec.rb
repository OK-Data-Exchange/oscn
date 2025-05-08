require 'rails_helper'

RSpec.describe Pd::Booking, type: :model do
  it { should have_many(:offenses).dependent(:destroy) }
end
