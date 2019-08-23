require "rails_helper"

RSpec.describe 'Create Reading', type: :request do
  include_context 'token based thermostat context'
  include_context 'redis context'

  describe 'POST create' do
    let(:params) do
      {
        humidity: 34.6,
        temperature: 24.5,
        battery_charge: 50.0
      }
    end

    context 'Unauthorized' do
      it 'should not create reading and return http status code: 401' do
        post '/reading', params: params, headers: {}

        body_json = JSON.parse(response.body)

        expect(response.status).to eq 401
        expect(body_json['type']).to eq 'Unauthorized'
        expect(body_json['message']).to eq 'Invalid Token'
      end
    end

    context 'Create reading with valid params' do
      it 'should create reading and return http status code: 201' do
        post '/reading', params: params, headers: auth_headers

        reading_json = JSON.parse(response.body)

        expect(response.status).to eq 201
        expect(reading_json['tracking_number']).to eq 1
        expect(reading_json['temperature']).to eq 24.5
        expect(reading_json['humidity']).to eq 34.6
        expect(reading_json['battery_charge']).to eq 50.0
      end
    end

    context 'Create reading with invalid params' do
      let(:params) do
        {
          humidity: 'wrong_value',
          temperature: 'wrong_value',
          battery_charge: 'wrong_value'
        }
      end

      it 'should not create reading and return http status code: 422' do
        post '/reading', params: params, headers: auth_headers

        reading_json = JSON.parse(response.body)

        expect(response.status).to eq 422
        expect(reading_json).to eq(
          {
            "type"=>"invalid params",
            "errors"=>[
              {"field"=>"temperature", "message"=>"is not a number"},
              {"field"=>"humidity", "message"=>"is not a number"},
              {"field"=>"battery_charge", "message"=>"is not a number"}
            ]
          }
        )
      end
    end
  end
end
