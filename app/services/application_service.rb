class ApplicationService
  attr_reader :redis_manager

  def initialize
    @redis_manager = RedisManager.new
  end
  
  def self.run(*args)
    new(*args).run
  end
end
