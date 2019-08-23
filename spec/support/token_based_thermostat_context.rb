RSpec.shared_context 'token based thermostat context', :shared_context do
  let(:thermostat) { FactoryBot.create(:thermostat) }
  let(:auth_headers) do
    { 'Authorization': thermostat.household_token }
  end
end
