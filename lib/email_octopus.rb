# frozen_string_literal: true
require 'active_model'
require 'net/http'
require 'json'
require 'email_octopus/version'

# Client for the EmailOctopus API
#
# https://emailoctopus.com/api-documentation/
module EmailOctopus
  include ActiveSupport::Configurable

  # Reload the model attributes on create and update
  # this ensures the object in memory has updated attributes when you make
  # a request. This state is true by default but you can disable it if you need
  # to.
  config_accessor :reload_models_on_create_and_update do
    true
  end

  extend ActiveSupport::Autoload

  autoload :API
  autoload :Model
  autoload :Campaign
  autoload :List
  autoload :Contact
  autoload :Query

  autoload_under 'api' do
    autoload :Response
    autoload :Error
  end

  autoload_under 'api/error' do
    autoload :ApiKeyInvalid
    autoload :InvalidParameters
    autoload :NotFound
    autoload :Unauthorized
  end
end
