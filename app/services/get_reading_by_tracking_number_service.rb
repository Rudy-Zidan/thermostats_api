class GetReadingByTrackingNumberService < ApplicationService
  attr_reader :thermostat, :tracking_number

  def initialize(thermostat:, tracking_number:)
    super()
    @thermostat = thermostat
    @tracking_number = tracking_number
  end

  def run
    reading = get_from_cache
    return reading if reading

    thermostat.readings.find_by!(tracking_number: tracking_number)
  end

  private

  def get_from_cache
    redis_manager.saved_reading(thermostat.id, tracking_number)
  end
end
