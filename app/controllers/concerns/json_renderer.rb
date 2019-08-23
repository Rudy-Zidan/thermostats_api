module JsonRenderer
  def render(*args)
    options = args.extract_options!
    options = handle_json(options) if options[:json].is_a?(ApplicationRecord)

    super(*(args << options))
  end

  private

  def handle_json(options)
    if options[:json].errors.any?
      options[:status] = :unprocessable_entity
      options[:json] = present_errors(options[:json].errors)
    else
      options[:json] = present_resource(options[:json])
    end

    options
  end

  def present_errors(validation_errors)
    Errors::ValidationErrorPresenter.new(validation_errors).present
  end

  def present_resource(resource)
    resource_class = resource.class.name
    "#{resource_class}Presenter".constantize.new(resource).present
  end
end
