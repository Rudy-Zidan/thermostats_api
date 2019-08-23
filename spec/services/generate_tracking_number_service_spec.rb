require 'rails_helper'

RSpec.describe GenerateTrackingNumberService do
  include_context 'redis context'

  describe '.run' do
    let(:thermostat) { FactoryBot.create(:thermostat) }

    context 'Generate tracking number for first time' do
      it 'Should get tracking number equal to 1' do
        tracking_number = described_class.run(thermostat.household_token)

        expect(tracking_number).to eq 1
      end
    end

    context 'Generate tracking number for second time' do
      before do
        described_class.run(thermostat.household_token)
      end

      it 'Should get tracking number equal to 2' do
        tracking_number = described_class.run(thermostat.household_token)

        expect(tracking_number).to eq 2
      end
    end
  end
end
