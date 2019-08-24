require "rails_helper"

RSpec.describe 'Get reading by tracking number', type: :request do
  include_context 'token based thermostat context'
  include_context 'redis context'

  describe 'GET show_by_tracking_number' do
    context 'Unauthorized' do
      it 'should not get reading and return http status code: 401' do
        get "/reading/#{1}", headers: {}

        body_json = JSON.parse(response.body)

        expect(response.status).to eq 401
        expect(body_json['type']).to eq 'Unauthorized'
        expect(body_json['message']).to eq 'Invalid Token'
      end
    end

    context 'Reading is saved on redis' do
      let(:thermostat) { FactoryBot.create(:thermostat) }
      let(:params) do
        params = {
          humidity: 34.6,
          temperature: 24.5,
          battery_charge: 50.0
        }
      end

      it 'should get reading and return http status code: 200' do
        reading = CreateReadingService.run(thermostat: thermostat, params: params)

        get "/reading/#{reading.tracking_number}", headers: auth_headers
        reading_json = JSON.parse(response.body)

        expect(response.status).to eq 200
        expect(reading_json['tracking_number']).to eq 1
        expect(reading_json['temperature']).to eq 24.5
        expect(reading_json['humidity']).to eq 34.6
        expect(reading_json['battery_charge']).to eq 50.0
      end
    end

    context 'Reading is saved on DB' do
      let(:reading) { FactoryBot.create(:reading, thermostat: thermostat) }

      it 'should get reading and return http status code: 200' do
        get "/reading/#{reading.tracking_number}", headers: auth_headers
        reading_json = JSON.parse(response.body)

        expect(response.status).to eq 200
        expect(reading_json['tracking_number']).to eq reading.tracking_number
        expect(reading_json['temperature']).to eq reading.temperature
        expect(reading_json['humidity']).to eq reading.humidity
        expect(reading_json['battery_charge']).to eq reading.battery_charge
      end
    end

    context 'Wrong tracking number' do
      it 'should return http status code: 404' do
        get "/reading/worng-tracking-number", headers: auth_headers
        reading_json = JSON.parse(response.body)

        expect(response.status).to eq 404
        expect(reading_json).to eq(
          {
            "type"=>"resource not found",
            "message"=>"Couldn't find Reading"
          }
        )
      end
    end
  end
end
