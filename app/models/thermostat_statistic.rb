class ThermostatStatistic
  attr_accessor :temperature, :humidity, :battery_charge, :count_of_readings

  def initialize
    default = {
      min: nil,
      max: nil,
      avg: nil,
      accumulative_value: 0,
    }

    @temperature = default.dup
    @humidity = default.dup
    @battery_charge = default.dup
    @count_of_readings = 0
  end
end
