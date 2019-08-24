class GetThermostatStatsService < ApplicationService
  attr_reader :thermostat

  def initialize(thermostat)
    super()
    @thermostat = thermostat
  end

  def run
    thermostat_statistic = redis_manager.saved_thermostat_statistic(thermostat.household_token)
    return ThermostatStatistic.new unless thermostat_statistic

    thermostat_statistic
  end
end
