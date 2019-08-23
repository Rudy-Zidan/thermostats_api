module Errors
  class UnauthorizedPresenter
    def self.present
      {
        type: 'Unauthorized',
        message: 'Invalid Token',
      }
    end
  end
end
