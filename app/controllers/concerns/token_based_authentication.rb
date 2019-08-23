module TokenBasedAuthentication
  def validate_request!
    @current_thermostat = Thermostat.find_by!(household_token: request.headers[:authorization])
  rescue => e
    unauthorized
  end

  private

  def unauthorized
    render json: Errors::UnauthorizedPresenter.present, status: :unauthorized
  end
end
