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
      @limit = num
      self
    end

    def page(num)
      reset_results
      @page = num
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
      }.each_with_object({}) do |memo, (key, val)|
        memo[key] = val unless val.nil?
      end
    end
  end
end
