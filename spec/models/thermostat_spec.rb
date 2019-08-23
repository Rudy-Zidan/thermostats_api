require 'rails_helper'

RSpec.describe Thermostat, type: :model do
  context "Associations" do
    it { should have_many :readings }
  end

  context 'Validations' do
    describe 'Required' do
      it { should validate_presence_of :household_token }
      it { should validate_presence_of :location }
    end
  end
end
