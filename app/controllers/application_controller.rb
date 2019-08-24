class ApplicationController < ActionController::API
  include TokenBasedAuthentication
  include JsonRenderer

  before_action :validate_request!

  rescue_from ActiveRecord::RecordNotFound, with: :resource_not_found

  private

  def resource_not_found(e)
    render json: Errors::NotFoundPresenter.new(e).present, status: :not_found
  end
end
