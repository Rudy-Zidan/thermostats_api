RSpec.shared_context 'redis context', :shared_context do
  after(:all) do
    Redis.current.flushall
  end
end
