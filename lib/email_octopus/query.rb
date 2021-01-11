# frozen_string_literal: true

module EmailOctopus
  # Runs a query on model data.
  class Query
    def initialize(model)
      @model = model
      @api = API.new(EmailOctopus.config.api_key)
      reset_results
    end

    def limit(num)
      reset_results
      @limit = validate_limit(num)
      self
    end

    def page(num)
      reset_results
      @page = validate_page(num)
      self
    end

    def results
      @results ||= @api.get(path, attributes).body['data'].map { |params| @model.new(params) }
    end

    private

    # ensure the results are reset whenever the Query objects page changes so
    # that new calls to results will use updated api response data
    def reset_results
      @results = nil
    end

    def path
      "/#{@model.model_name.collection.split('/').last}"
    end

    def attributes
      {
        limit: @limit,
        page: @page
      }
    end

    # ensure that limits are between 1-100
    def validate_limit(value)
      return 1 if value < 1
      return 100 if value > 100
      value.to_i
    end

    # ensure that pages are not less than 1
    def validate_page(value)
      return 1 if value < 1
      value.to_i
    end
  end
end
