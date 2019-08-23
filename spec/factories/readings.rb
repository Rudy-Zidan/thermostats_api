FactoryBot.define do
  factory :reading do
    thermostat
    tracking_number { rand(1..100) }
    temperature { rand(-25.5..30.0) }
    humidity { rand(0.5..30.0) }
    battery_charge { rand(0.0..100.0) }
  end
end
