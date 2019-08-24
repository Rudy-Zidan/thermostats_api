class StatsController < ApplicationController
  def index
    render json: GetThermostatStatsService.run(@current_thermostat), status: :ok
  end
end
