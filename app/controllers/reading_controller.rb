class ReadingController < ApplicationController
  def create
    reading = CreateReadingService.run(
      thermostat: @current_thermostat,
      params: reading_params
    )

    render json: reading, status: :created
  end

  def show_by_tracking_number
    reading = GetReadingByTrackingNumberService.run(
      thermostat: @current_thermostat,
      tracking_number: params[:tracking_number]
    )

    render json: reading, status: :ok
  end

  private

  def reading_params
    params.permit(:humidity, :temperature, :battery_charge).to_h.symbolize_keys
  end
end
