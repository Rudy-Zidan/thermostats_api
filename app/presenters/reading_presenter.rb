class ReadingPresenter
  attr_reader :reading

  def initialize(reading)
    @reading = reading
  end

  def present
    {
      tracking_number: reading.tracking_number,
      temperature: reading.temperature,
      humidity: reading.humidity,
      battery_charge: reading.battery_charge
    }
  end
end
