RSpec.shared_context 'redis context', :shared_context do
  let(:redis_manager) { RedisManager.new }
  
  after(:all) do
    Redis.current.flushall
  end
end
