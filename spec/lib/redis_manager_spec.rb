require 'rails_helper'

RSpec.describe RedisManager do
  include_context 'redis context'

  describe '.next_tracking_number_for_key' do
    let(:thermostat) { FactoryBot.create(:thermostat) }

    context 'Next tracking number for first time' do
      it 'Should get tracking number equal to 1' do
        tracking_number = redis_manager.next_tracking_number_for(thermostat.household_token)

        expect(tracking_number).to eq 1
      end
    end

    context 'Next tracking number for second time' do
      before do
        redis_manager.next_tracking_number_for(thermostat.household_token)
      end

      it 'Should get tracking number equal to 2' do
        tracking_number = redis_manager.next_tracking_number_for(thermostat.household_token)

        expect(tracking_number).to eq 2
      end
    end
  end

  describe '.save_reading' do
    let(:reading) { FactoryBot.create(:reading) }

    it 'Should cache reading into redis' do
      expect(redis_manager.save_reading(reading)).to eq "OK"
    end
  end

  describe '.saved_reading' do
    let(:reading) { FactoryBot.create(:reading) }
    let(:reading2) { FactoryBot.create(:reading) }

    before do
      redis_manager.save_reading(reading)
      redis_manager.save_reading(reading2)
    end

    it 'Should cache reading into redis' do
      cached_reading = redis_manager.saved_reading(reading.thermostat_id, reading.tracking_number)

      expect(cached_reading).not_to be_nil
      expect(cached_reading).to be_instance_of(Reading)
      expect(cached_reading.id).to eq(reading.id)
      expect(cached_reading.thermostat_id).to eq(reading.thermostat_id)
      expect(cached_reading.tracking_number).to eq(reading.tracking_number)
      expect(cached_reading.humidity).to eq(reading.humidity)
      expect(cached_reading.temperature).to eq(reading.temperature)
    end
  end

  describe '.purge_saved_reading' do
    let(:reading) { FactoryBot.create(:reading) }

    before do
      redis_manager.save_reading(reading)
    end

    it 'Should purge cached reading from redis' do
      cached_reading = redis_manager.purge_saved_reading(reading)
      cached_reading = redis_manager.saved_reading(reading.thermostat_id, reading.tracking_number)

      expect(cached_reading).to be_nil
    end
  end
end
