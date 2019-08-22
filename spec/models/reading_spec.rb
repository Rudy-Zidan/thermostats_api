require 'rails_helper'

RSpec.describe Reading, type: :model do
  context "Associations" do
    it { should belong_to :thermostat }
  end
end
