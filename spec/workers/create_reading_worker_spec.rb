require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe CreateReadingWorker, type: :worker do
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

    it 'should create a reading into DB' do
      expect do
        described_class.new.perform(reading_params)
      end.to change(thermostat.readings, :count).by(1)
    end
  end
end
