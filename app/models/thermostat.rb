class Thermostat < ApplicationRecord
  has_many :readings

  validates :location, :household_token, presence: true
end
