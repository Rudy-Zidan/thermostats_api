class ThermostatStatsCalculatorService < ApplicationService
  attr_reader :thermostat, :reading, :thermostat_statistic

  def initialize(thermostat:, reading:)
    super()
    @thermostat = thermostat
    @reading = reading
    find_or_initialize_thermostat_statistic
  end

  def run
    calculate_statistics
    save_thermostat_statistic_on_redis
    thermostat_statistic
  end

  private

  def find_or_initialize_thermostat_statistic
    @thermostat_statistic = get_thermostat_statistic_from_redis || ThermostatStatistic.new
  end

  def calculate_statistics
    thermostat_statistic.count_of_readings += 1

    %i(temperature humidity battery_charge).each do |field|
      calculate_field_statistics(field)
    end
  end

  def calculate_field_statistics(field)
    current_value = reading.send(field)
    min, max = get_current_limits(thermostat_statistic.send(field))
    thermostat_statistic.send(field)[:min] = get_value_based_on_criteria(
      old_value: min,
      new_value: current_value,
      criteria: 'min'
    )
    thermostat_statistic.send(field)[:max] = get_value_based_on_criteria(
      old_value: max,
      new_value: current_value,
      criteria: 'max'
    )
    thermostat_statistic.send(field)[:accumulative_value] += current_value
    thermostat_statistic.send(field)[:avg] = calculate_avg(field)
  end

  def get_current_limits(field)
    [field[:min], field[:max]]
  end

  def get_value_based_on_criteria(old_value:, new_value:, criteria:)
    return new_value unless old_value

    [old_value, new_value].send(criteria)
  end

  def calculate_avg(field)
    thermostat_statistic.send(field)[:accumulative_value] / thermostat_statistic.count_of_readings
  end

  def get_thermostat_statistic_from_redis
    redis_manager.saved_thermostat_statistic(thermostat.household_token)
  end

  def save_thermostat_statistic_on_redis
    redis_manager.save_thermostat_statistic(thermostat.household_token, thermostat_statistic)
  end
end
