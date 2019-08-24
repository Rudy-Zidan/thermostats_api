require 'rails_helper'

RSpec.describe ThermostatStatsCalculatorService do
  include_context 'redis context'

  describe '.run' do
    context 'Calculate Stats for first time' do
      let(:thermostat) { FactoryBot.create(:thermostat) }
      let(:reading) { FactoryBot.create(:reading, thermostat: thermostat) }

      it 'Should calculate stats' do
        thermostat_statistic = described_class.run(thermostat: thermostat, reading: reading)

        expect(thermostat_statistic).to be_instance_of(ThermostatStatistic)
        expect(thermostat_statistic.temperature[:min]).to eq reading.temperature
        expect(thermostat_statistic.temperature[:max]).to eq reading.temperature
        expect(thermostat_statistic.temperature[:avg]).to eq reading.temperature
        expect(thermostat_statistic.temperature[:accumulative_value]).to eq reading.temperature

        expect(thermostat_statistic.humidity[:min]).to eq reading.humidity
        expect(thermostat_statistic.humidity[:max]).to eq reading.humidity
        expect(thermostat_statistic.humidity[:avg]).to eq reading.humidity
        expect(thermostat_statistic.humidity[:accumulative_value]).to eq reading.humidity

        expect(thermostat_statistic.battery_charge[:min]).to eq reading.battery_charge
        expect(thermostat_statistic.battery_charge[:max]).to eq reading.battery_charge
        expect(thermostat_statistic.battery_charge[:avg]).to eq reading.battery_charge
        expect(thermostat_statistic.battery_charge[:accumulative_value]).to eq reading.battery_charge

        expect(thermostat_statistic.count_of_readings).to eq 1
      end
    end

    context 'Calculate Stats for second time' do
      let(:thermostat) { FactoryBot.create(:thermostat) }
      let(:old_reading) { FactoryBot.create(:reading, thermostat: thermostat) }
      let(:new_reading) { FactoryBot.create(:reading, thermostat: thermostat) }

      it 'Should calculate stats affected by old one' do
        old_thermostat_statistic = described_class.run(thermostat: thermostat, reading: old_reading)
        new_thermostat_statistic = described_class.run(thermostat: thermostat, reading: new_reading)

        expect(new_thermostat_statistic).to be_instance_of(ThermostatStatistic)
        expect(new_thermostat_statistic.temperature[:min]).to eq [old_reading.temperature, new_reading.temperature].min
        expect(new_thermostat_statistic.temperature[:max]).to eq [old_reading.temperature, new_reading.temperature].max
        expect(new_thermostat_statistic.temperature[:avg]).to eq (old_reading.temperature + new_reading.temperature) / 2
        expect(new_thermostat_statistic.temperature[:accumulative_value]).to eq old_reading.temperature + new_reading.temperature

        expect(new_thermostat_statistic.humidity[:min]).to eq [old_reading.humidity, new_reading.humidity].min
        expect(new_thermostat_statistic.humidity[:max]).to eq [old_reading.humidity, new_reading.humidity].max
        expect(new_thermostat_statistic.humidity[:avg]).to eq (old_reading.humidity + new_reading.humidity) / 2
        expect(new_thermostat_statistic.humidity[:accumulative_value]).to eq old_reading.humidity + new_reading.humidity

        expect(new_thermostat_statistic.battery_charge[:min]).to eq [old_reading.battery_charge, new_reading.battery_charge].min
        expect(new_thermostat_statistic.battery_charge[:max]).to eq [old_reading.battery_charge, new_reading.battery_charge].max
        expect(new_thermostat_statistic.battery_charge[:avg]).to eq (old_reading.battery_charge + new_reading.battery_charge) / 2
        expect(new_thermostat_statistic.battery_charge[:accumulative_value]).to eq old_reading.battery_charge + new_reading.battery_charge

        expect(new_thermostat_statistic.count_of_readings).to eq 2
      end
    end
  end
end
