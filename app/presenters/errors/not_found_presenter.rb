module Errors
  class NotFoundPresenter
    attr_reader :exception

    def initialize(exception)
      @exception = exception
    end

    def present
      entity = exception.model.split('::').last.underscore.humanize
      {
        type: 'resource not found',
        message: "Couldn't find #{entity}"
      }
    end
  end
end
