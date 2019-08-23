class Reading < ApplicationRecord
  belongs_to :thermostat

  validates :tracking_number, :temperature, :humidity, :battery_charge, presence: true
  validates :temperature, :humidity, :battery_charge, numericality: true
  validates :tracking_number, numericality: { greater_than: 0, only_integer: true }

  after_create :purge_cached_reading

  private

  def purge_cached_reading
    RedisManager.new.purge_saved_reading(self)
  end
end
