require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe CreateReadingWorker, type: :worker do
  include_context 'redis context'

  describe '.perform_async' do
    context 'queue' do
      it "job in correct queue" do
        described_class.perform_async
        assert_equal :reading, described_class.queue
      end
    end

    context 'jobs' do
      it 'goes into the jobs array' do
        expect do
          described_class.perform_async
        end.to change(described_class.jobs, :size).by(1)
      end
    end
  end

  describe '.perform' do
    let(:thermostat) { FactoryBot.create(:thermostat) }
    let(:reading_params) do
      {
        tracking_number: 1,
        thermostat_id: thermostat.id,
        humidity: 34.6,
        temperature: 24.5,
        battery_charge: 50.0
      }
    end
    let(:reading) { FactoryBot.build(:reading, reading_params)}
    let(:redis_manager) { RedisManager.new }

    it 'should create a reading into DB' do
      expect do
        described_class.new.perform(reading_params)
      end.to change(thermostat.readings, :count).by(1)
    end

    it 'should create a reading into DB and remove cached reading' do
      redis_manager.save_reading(reading)

      expect do
        described_class.new.perform(reading_params)
      end.to change(thermostat.readings, :count).by(1)

      saved_reading = redis_manager.saved_reading(reading.thermostat_id, reading.tracking_number)

      expect(saved_reading).to be_nil
    end
  end
end
