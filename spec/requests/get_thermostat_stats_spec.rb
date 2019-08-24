require "rails_helper"

RSpec.describe 'Get thermostat stats', type: :request do
  include_context 'token based thermostat context'
  include_context 'redis context'

  describe 'GET index' do
    context 'Unauthorized' do
      it 'should not get thermostat stats and return http status code: 401' do
        get '/stats', headers: {}

        body_json = JSON.parse(response.body)

        expect(response.status).to eq 401
        expect(body_json['type']).to eq 'Unauthorized'
        expect(body_json['message']).to eq 'Invalid Token'
      end
    end

    context 'With valid token and no stats saved on redis' do
      let(:default_data) do
        {
          min: nil,
          max: nil,
          avg: nil,
        }.stringify_keys
      end

      it 'should get default thermostat stats and return http status code: 200' do
        get '/stats', headers: auth_headers

        body_json = JSON.parse(response.body)

        expect(response.status).to eq 200
        expect(body_json['temperature']).to eq default_data
        expect(body_json['humidity']).to eq default_data
        expect(body_json['battery_charge']).to eq default_data
      end
    end

    context 'With valid token and stats saved on redis' do
      let(:params) do
        {
          humidity: 34.6,
          temperature: 24.5,
          battery_charge: 50.0
        }
      end

      before do
        CreateReadingService.run(thermostat: thermostat, params: params)
      end

      it 'should get thermostat stats and return http status code: 200' do
        get '/stats', headers: auth_headers

        body_json = JSON.parse(response.body)

        expect(response.status).to eq 200
        expect(body_json['temperature']['min']).to eq params[:temperature]
        expect(body_json['temperature']['max']).to eq params[:temperature]
        expect(body_json['humidity']['min']).to eq params[:humidity]
        expect(body_json['humidity']['max']).to eq params[:humidity]
        expect(body_json['humidity']['min']).to eq params[:humidity]
        expect(body_json['battery_charge']['max']).to eq params[:battery_charge]
      end
    end
  end
end
