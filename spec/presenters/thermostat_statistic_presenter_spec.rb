require 'rails_helper'

RSpec.describe ThermostatStatisticPresenter do
  describe '.present' do
    let(:thermostat_statistic) { FactoryBot.build(:thermostat_statistic) }

    it 'should present thermostat_statistic object' do
      presented_thermostat_statistic = described_class.new(thermostat_statistic).present

      expect(presented_thermostat_statistic).not_to be_nil
      expect(presented_thermostat_statistic).to be_instance_of(Hash)
      expect(presented_thermostat_statistic[:temperature]).to eq thermostat_statistic.temperature.except(:accumulative_value)
      expect(presented_thermostat_statistic[:humidity]).to eq thermostat_statistic.humidity.except(:accumulative_value)
      expect(presented_thermostat_statistic[:battery_charge]).to eq thermostat_statistic.battery_charge.except(:accumulative_value)
    end
  end
end
