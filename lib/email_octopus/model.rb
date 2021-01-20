# frozen_string_literal: true
require 'email_octopus/api'
require 'active_model/naming'

module EmailOctopus
  # Common code for model objects.
  class Model
    extend ActiveModel::Naming

    # @!attribute attributes [r]
    #   @return [Hash] Attributes related to this model.
    attr_reader :attributes

    # @param params [Hash] Initial attributes for this model.
    def initialize(params = {})
      @attributes = params.transform_keys(&:to_s)
      @api = API.new(EmailOctopus.config.api_key)
    end

    # Instantiate a new resource and immediately persist it on the API.
    #
    # @param params [Hash] Initial attributes to save.
    def self.create(params = {})
      new(params).tap(&:save)
    end

    # Find a resource by its given ID.
    #
    # @param id [String] ID provided by EmailOctopus for this resource.
    # @return [Model] instance for this model class.
    def self.find(id)
      new(id: id).tap(&:persisted?)
    end

    # Start a new query on a group of model resources.
    #
    # @param page [Integer] A specific page to return records from.
    # @param limit [Integer] The number of records to return per page.
    # @return [Query] for this model class.
    def self.all(page:1, limit:100)
      Query.new self, page, limit
    end

    # Delegate all class method calls that aren't defined on the model
    # class to its +Query+.
    #
    # @param method [Symbol] Name of the method to call.
    # @param arguments [Array] Arguments to pass to the method.
    # @throws [NoMethodError] when method not defined on +all+
    # @return [Query]
    def self.method_missing(method, *arguments)
      return super unless respond_to? method
      all.public_send method, *arguments
    end

    def self.respond_to_missing?(method, include_private = false)
      true
    end

    # Define a new attribute method on the model that reads from the
    # +attributes+ hash.
    #
    # @param name [Symbol] Name of the attribute
    def self.attribute(name, default_value=nil)
      define_method name.to_s do
        attributes[name.to_s]
      end

      define_method "#{name}=" do |value|
        attributes[name.to_s] = value
      end
    end

    #
    def persisted?
      id.present? && reload!
    end

    # Run validations and persist to the database.
    def save
      persist!
    end

    def as_json
      attributes
    end

    def destroy
      @api.delete(path, {}).success?
    end

    def reload!
      request = @api.get(path, {})
      new_attributes = request.body['data'][0].transform_keys(&:to_s)

      @attributes = @attributes.merge new_attributes
      request.success?
    end

    private

    def create
      return false if id.present?
      response = @api.post(base_path, as_json)
      is_successful = response.success?
      reload! if will_reload_response?(is_successful)
      is_successful
    end

    def update
      return false unless id.present?
      response = @api.put(path, as_json)
      is_successful = response.success?
      reload! if will_reload_response?(is_successful)
      is_successful
    end

    def will_reload_response?(is_successful=false)
      is_successful and EmailOctopus.config.reload_models_on_create_and_update
    end

    def persist!
      create || update
    end

    def base_path
      "/#{model_name.collection.split('/').last}"
    end

    def path
      "#{base_path}/#{id}"
    end
  end
end
