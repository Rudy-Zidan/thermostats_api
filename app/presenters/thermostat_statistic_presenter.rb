class ThermostatStatisticPresenter
  attr_reader :thermostat_statistic

  def initialize(thermostat_statistic)
    @thermostat_statistic = thermostat_statistic
  end

  def present
    {
      temperature: thermostat_statistic.temperature.except(:accumulative_value),
      humidity: thermostat_statistic.humidity.except(:accumulative_value),
      battery_charge: thermostat_statistic.battery_charge.except(:accumulative_value),
    }
  end
end
