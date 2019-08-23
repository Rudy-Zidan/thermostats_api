require 'rails_helper'

RSpec.describe CreateReadingService do
  include_context 'redis context'

  describe '.run' do
    let(:thermostat) { FactoryBot.create(:thermostat) }

    context 'Create reading with valid params' do
      let(:params) do
        {
          humidity: 34.6,
          temperature: 24.5,
          battery_charge: 50.0
        }
      end

      it 'Should return a cached reading' do
        reading = described_class.run(thermostat: thermostat, params: params)

        expect(reading).to be_instance_of(Reading)
        expect(reading.id).to be_nil
        expect(reading.tracking_number).to eq 1
        expect(reading.errors.empty?).to be_truthy
      end

      it 'Should trigger CreateReadingWorker' do
        expect do
          described_class.run(thermostat: thermostat, params: params)
        end.to change(CreateReadingWorker.jobs, :size).by(1)
      end

      it 'Should save reading into redis' do
        reading = described_class.run(thermostat: thermostat, params: params)
        redis_manager = RedisManager.new

        saved_reading = redis_manager.saved_reading(
          reading.thermostat_id,
          reading.tracking_number
        )

        expect(saved_reading).to be_instance_of(Reading)
        expect(saved_reading.tracking_number).to eq reading.tracking_number
        expect(saved_reading.thermostat_id).to eq reading.thermostat_id
      end
    end

    context 'Create reading with invalid params' do
      let(:params) do
        {
          humidity: 'wrong value',
          temperature: 'wrong value',
          battery_charge: 'wrong value'
        }
      end

      it 'Should return a reading with errors' do
        reading = described_class.run(thermostat: thermostat, params: params)

        expect(reading.errors.any?).to be_truthy
        expect(reading.errors.size).to eq 3
        reading.errors.each do |field, message|
          expect(message).to eq("is not a number")
        end
      end

      it 'Should not trigger CreateReadingWorker' do
        expect do
          described_class.run(thermostat: thermostat, params: params)
        end.to change(CreateReadingWorker.jobs, :size).by(0)
      end

      it 'Should not save reading into redis' do
        reading = described_class.run(thermostat: thermostat, params: params)
        redis_manager = RedisManager.new

        saved_reading = redis_manager.saved_reading(
          reading.thermostat_id,
          reading.tracking_number
        )

        expect(saved_reading).to be_nil
      end
    end
  end
end
