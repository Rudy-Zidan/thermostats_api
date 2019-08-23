require 'sidekiq'

redis_config = Rails.application.config.redis.with_indifferent_access

expiration = 30.minutes
redis_url = "#{redis_config[:url]}/#{redis_config[:sidekiq_db]}"

Encoding.default_external = Encoding::UTF_8

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url, id: nil, network_timeout: 5 }

  config.server_middleware do |chain|
    chain.add Sidekiq::Status::ServerMiddleware, expiration: expiration
  end

  config.client_middleware do |chain|
    chain.add Sidekiq::Status::ClientMiddleware, expiration: expiration
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url, id: nil, network_timeout: 5 }

  config.client_middleware do |chain|
    chain.add Sidekiq::Status::ClientMiddleware, expiration: expiration
  end
end

require 'sidekiq/web'
require 'sidekiq-status/web'

sidekiq_web_config = Rails.application.config.sidekiq_web.with_indifferent_access

Sidekiq::Web.use(Rack::Auth::Basic) do |username, password|
  [username, password] == [sidekiq_web_config[:username], sidekiq_web_config[:password]]
end

module Sidekiq
  # Sidekiq::Logging
  module Logging
    # override existing log to include the arguments passed to `perform`
    def self.job_hash_context(job_hash)
      klass = job_hash['wrapped'] || job_hash['class']
      bid = job_hash['bid']
      args = job_hash['args']
      "#{klass} ARGS-#{args} JID-#{job_hash['jid']} BID-#{bid}"
    end
  end
end
