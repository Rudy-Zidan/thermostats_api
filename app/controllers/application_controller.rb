class ApplicationController < ActionController::API
  include TokenBasedAuthentication
  include JsonRenderer

  before_action :validate_request!
end
