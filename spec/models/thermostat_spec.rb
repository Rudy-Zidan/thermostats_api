require 'rails_helper'

RSpec.describe Thermostat, type: :model do
  context "Associations" do
    it { should have_many :readings }
  end
end
