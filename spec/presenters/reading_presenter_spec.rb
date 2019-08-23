require 'rails_helper'

RSpec.describe ReadingPresenter do
  describe '.present' do
    let(:reading) { FactoryBot.create(:reading) }

    it 'should present reading object' do
      presented_reading = described_class.new(reading).present

      expect(presented_reading).not_to be_nil
      expect(presented_reading).to be_instance_of(Hash)
      expect(presented_reading[:humidity]).to eq reading.humidity
      expect(presented_reading[:temperature]).to eq reading.temperature
      expect(presented_reading[:battery_charge]).to eq reading.battery_charge
      expect(presented_reading[:tracking_number]).to eq reading.tracking_number
    end
  end
end
