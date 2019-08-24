FactoryBot.define do
  factory :thermostat_statistic do
    count_of_readings { 5 }
    temperature do
      {
        min: rand(-25.5..30.0),
        max: rand(-32.0..70.0),
        avg: 50.0,
        accumulative_value: 100.0
      }
    end

    humidity do
      {
        min: rand(-25.5..30.0),
        max: rand(-32.0..70.0),
        avg: 50.0,
        accumulative_value: 100.0
      }
    end

    battery_charge do
      {
        min: rand(-25.5..30.0),
        max: rand(-32.0..70.0),
        avg: 50.0,
        accumulative_value: 100.0
      }
    end
  end
end
