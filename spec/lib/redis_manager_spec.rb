require 'rails_helper'

RSpec.describe RedisManager do
  include_context 'redis context'

  describe '.next_tracking_number_for_key' do
    let(:thermostat) { FactoryBot.create(:thermostat) }
    let(:redis_manager) { RedisManager.new }

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
end
