class RedisManager
  def initialize
    @redis = Redis.current
  end

  def next_tracking_number_for(key)
    key = "tracking_number_#{key}"
    tracking_number = @redis.get(key).to_i + 1
    @redis.set(key, tracking_number)
    tracking_number
  end
end
