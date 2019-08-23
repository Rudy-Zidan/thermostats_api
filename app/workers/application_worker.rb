class ApplicationWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  RETRY_INTERVAL = 20

  sidekiq_options retry: 5

  sidekiq_retry_in do |count|
    RETRY_INTERVAL * (count + 1)
  end

  sidekiq_retries_exhausted do |msg, _ex|
    Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
  end
end
