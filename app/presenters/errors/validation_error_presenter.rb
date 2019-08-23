module Errors
  class ValidationErrorPresenter
    attr_reader :errors

    def initialize(errors)
      @errors = errors
    end

    def present
      {
        type: 'invalid params',
        errors: errors.map do |field, message|
          {
            field: field,
            message: message
          }
        end
      }
    end
  end
end
