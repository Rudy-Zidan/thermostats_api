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
    set_object_on_redis(key, reading)
  end

  def saved_reading(thermostat_id, tracking_number)
    key = inprogress_reading_key(thermostat_id, tracking_number)
    get_object_from_redis(key)
  end

  def purge_saved_reading(reading)
    key = inprogress_reading_key(reading.thermostat_id, reading.tracking_number)
    @redis.del(key)
  end

  def save_thermostat_statistic(thermostat_token, thermostat_statistic)
    key = thermostat_statistic_key(thermostat_token)
    set_object_on_redis(key, thermostat_statistic)
  end

  def saved_thermostat_statistic(thermostat_token)
    key = thermostat_statistic_key(thermostat_token)
    get_object_from_redis(key)
  end

  private

  def inprogress_reading_key(thermostat_id, tracking_number)
    "inprogress_reading_#{thermostat_id}_#{tracking_number}"
  end

  def thermostat_statistic_key(thermostat_token)
    "thermostat_stats_#{thermostat_token}"
  end

  def set_object_on_redis(key, object)
    @redis.set(key, Marshal.dump(object))
  end

  def get_object_from_redis(key)
    object = @redis.get(key)
    return unless object

    Marshal.load(object)
  end
end
