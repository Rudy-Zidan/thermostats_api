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

      it 'Should create with different tracking_number' do
        result = []
        total_readings = 500
        threads = total_readings.times.map do |i|
          Thread.new do
            result << described_class.run(thermostat: thermostat, params: params)
          end
        end
        threads.each(&:join)
        tracking_numbers = (1..total_readings).to_a

        expect(result.pluck(:tracking_number).sort).to eq tracking_numbers
      end

      it 'Should trigger CreateReadingWorker' do
        expect do
          described_class.run(thermostat: thermostat, params: params)
        end.to change(CreateReadingWorker.jobs, :size).by(1)
      end

      it 'Should calculate thermostat_stats' do
        reading = described_class.run(thermostat: thermostat, params: params)
        saved_thermostat_statistic = GetThermostatStatsService.run(thermostat)

        expect(saved_thermostat_statistic.temperature[:min]).to eq reading.temperature
        expect(saved_thermostat_statistic.temperature[:max]).to eq reading.temperature
        expect(saved_thermostat_statistic.temperature[:avg]).to eq reading.temperature

        expect(saved_thermostat_statistic.humidity[:min]).to eq reading.humidity
        expect(saved_thermostat_statistic.humidity[:max]).to eq reading.humidity
        expect(saved_thermostat_statistic.humidity[:avg]).to eq reading.humidity

        expect(saved_thermostat_statistic.battery_charge[:min]).to eq reading.battery_charge
        expect(saved_thermostat_statistic.battery_charge[:max]).to eq reading.battery_charge
        expect(saved_thermostat_statistic.battery_charge[:avg]).to eq reading.battery_charge
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

      let(:default_data) do
        {
          min: nil,
          max: nil,
          avg: nil,
          accumulative_value: 0
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

      it 'Should get default thermostat_stats' do
        reading = described_class.run(thermostat: thermostat, params: params)
        saved_thermostat_statistic = GetThermostatStatsService.run(thermostat)

        expect(saved_thermostat_statistic.temperature).to eq default_data
        expect(saved_thermostat_statistic.humidity).to eq default_data
        expect(saved_thermostat_statistic.battery_charge).to eq default_data
      end
    end
  end
end
