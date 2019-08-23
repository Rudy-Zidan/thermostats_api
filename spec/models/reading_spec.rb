require 'rails_helper'

RSpec.describe Reading, type: :model do
  context 'Associations' do
    it { should belong_to :thermostat }
  end

  context 'Validations' do
    describe 'Required' do
      it { should validate_presence_of :tracking_number }
      it { should validate_presence_of :temperature }
      it { should validate_presence_of :humidity }
      it { should validate_presence_of :battery_charge }
    end

    describe 'Numericality' do
      it { should validate_numericality_of(:tracking_number).is_greater_than(0).only_integer }
      it { should validate_numericality_of(:temperature) }
      it { should validate_numericality_of(:humidity) }
      it { should validate_numericality_of(:battery_charge) }
    end
  end
end
