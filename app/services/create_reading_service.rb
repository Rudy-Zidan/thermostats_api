class CreateReadingService < ApplicationService
  attr_reader :thermostat, :params

  def initialize(thermostat:, params:)
    super()
    @thermostat = thermostat
    @params = params
  end

  def run
    params = build_reading_params
    reading = Reading.new(params)
    return reading unless reading.valid?

    CreateReadingWorker.perform_async(params)
    recalculate_thermostat_stats(reading)
    cache_reading(reading)
    reading
  end

  private

  def generate_tracking_number
    GenerateTrackingNumberService.run(thermostat.household_token)
  end

  def build_reading_params
    params.merge!(
      {
        thermostat_id: thermostat.id,
        tracking_number: generate_tracking_number
      }
    )
  end

  def cache_reading(reading)
    redis_manager.save_reading(reading)
  end

  def recalculate_thermostat_stats(reading)
    ThermostatStatsCalculatorService.run(thermostat: thermostat, reading: reading)
  end
end
