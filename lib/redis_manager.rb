class RedisManager
  def initialize
    @redis = Redis.current
  end

  def next_tracking_number_for(string)
    key = "tracking_number_#{string}"
    tracking_number = @redis.get(key).to_i + 1
    @redis.set(key, tracking_number)
    tracking_number
  end

  def save_reading(reading)
    key = inprogress_reading_key(reading.thermostat_id, reading.tracking_number)
    @redis.set(key, Marshal.dump(reading))
  end

  def saved_reading(thermostat_id, tracking_number)
    key = inprogress_reading_key(thermostat_id, tracking_number)
    reading = @redis.get(key)
    return unless reading

    Marshal.load(reading)
  end

  def purge_saved_reading(reading)
    key = inprogress_reading_key(reading.thermostat_id, reading.tracking_number)
    @redis.del(key)
  end

  private

  def inprogress_reading_key(thermostat_id, tracking_number)
    "inprogress_reading_#{thermostat_id}_#{tracking_number}"
  end
end
