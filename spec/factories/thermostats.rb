FactoryBot.define do
  factory :thermostat do
    household_token { SecureRandom.hex(15) }
    location { Faker::Address.street_address }
  end
end
