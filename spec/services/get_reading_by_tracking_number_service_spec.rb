require 'rails_helper'

RSpec.describe GetReadingByTrackingNumberService do
  include_context 'redis context'

  describe '.run' do
    context 'Reading is saved on redis' do
      let(:thermostat) { FactoryBot.create(:thermostat) }
      let(:params) do
        params = {
          humidity: 34.6,
          temperature: 24.5,
          battery_charge: 50.0
        }
      end

      it 'Should return reading' do
        reading = CreateReadingService.run(thermostat: thermostat, params: params)
        saved_reading = described_class.run(thermostat: thermostat, tracking_number: reading.tracking_number)

        expect(saved_reading.id).to be_nil
        expect(saved_reading.tracking_number).to eq(reading.tracking_number)
        expect(saved_reading.thermostat_id).to eq(reading.thermostat_id)
      end
    end

    context 'Reading is saved on DB' do
      let(:reading) { FactoryBot.create(:reading) }

      it 'Should return reading' do
        saved_reading = described_class.run(thermostat: reading.thermostat, tracking_number: reading.tracking_number)

        expect(saved_reading.id).to eq(reading.id)
        expect(saved_reading.tracking_number).to eq(reading.tracking_number)
        expect(saved_reading.thermostat_id).to eq(reading.thermostat_id)
      end
    end

    context 'Wrong tracking number' do
      let(:thermostat) { FactoryBot.create(:thermostat) }

      it 'Should raise record not found exception' do
        expect do
          described_class.run(thermostat: thermostat, tracking_number: 'wrong value')
        end.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end
end
