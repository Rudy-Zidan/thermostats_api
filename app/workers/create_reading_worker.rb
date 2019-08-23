class CreateReadingWorker < ApplicationWorker
  sidekiq_options queue: :reading, backtrace: true

  def perform(options = {})
    options = options.with_indifferent_access
    thermostat = Thermostat.find_by(id: options[:thermostat_id])
    return unless thermostat

    thermostat.readings.create(options.except(:thermostat_id))
  end
end
