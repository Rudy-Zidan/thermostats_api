class GenerateTrackingNumberService < BaseService
  attr_reader :household_token, :redis_manager

  def initialize(household_token)
    @household_token = household_token
    @redis_manager = RedisManager.new
  end

  def run
    redis_manager.next_tracking_number_for(household_token)
  end
end
