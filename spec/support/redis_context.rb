RSpec.shared_context 'redis context', :shared_context do
  after(:each) do
    Redis.current.flushall
  end
end
