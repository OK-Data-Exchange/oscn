require 'rails_helper'

RSpec.describe CaseHtmlValidator::ValidateAll do
  it 'successfully validates html' do
    expectation = expect { described_class.perform(from_fixture: true) }
    expectation.not_to output(/did not pass/).to_stdout
  end
end
