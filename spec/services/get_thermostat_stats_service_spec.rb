require 'rails_helper'

RSpec.describe GetThermostatStatsService do
  include_context 'redis context'

  describe '.run' do
    context 'ThermostatStatistic is saved on redis' do
      let(:thermostat) { FactoryBot.create(:thermostat) }
      let(:thermostat_statistic) { FactoryBot.build(:thermostat_statistic) }
      let(:redis_manager) { RedisManager.new }

      before do
        redis_manager.save_thermostat_statistic(thermostat.household_token, thermostat_statistic)
      end

      it 'Should return thermostat_statistic' do
        saved_thermostat_statistic = described_class.run(thermostat)

        expect(saved_thermostat_statistic.temperature).to eq(thermostat_statistic.temperature)
        expect(saved_thermostat_statistic.humidity).to eq(thermostat_statistic.humidity)
        expect(saved_thermostat_statistic.battery_charge).to eq(thermostat_statistic.battery_charge)
      end
    end

    context 'ThermostatStatistic is not saved on redis' do
      let(:thermostat) { FactoryBot.create(:thermostat) }
      let(:default_data) do
        {
          min: nil,
          max: nil,
          avg: nil,
          accumulative_value: 0
        }
      end

      it 'Should return default thermostat_statistic' do
        saved_thermostat_statistic = described_class.run(thermostat)

        expect(saved_thermostat_statistic.temperature).to eq(default_data)
        expect(saved_thermostat_statistic.humidity).to eq(default_data)
        expect(saved_thermostat_statistic.battery_charge).to eq(default_data)
      end
    end
  end
end
