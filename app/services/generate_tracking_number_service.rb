class GenerateTrackingNumberService < ApplicationService
  attr_reader :household_token

  def initialize(household_token)
    super()
    @household_token = household_token
  end

  def run
    redis_manager.lock("tracking_number_lock_#{household_token}") do
      redis_manager.next_tracking_number_for(household_token)
    end
  end
end
