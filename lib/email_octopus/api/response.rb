# frozen_string_literal: true

require 'email_octopus/api/error/api_key_invalid'
require 'email_octopus/api/error/invalid_parameters'
require 'email_octopus/api/error/not_found'
require 'email_octopus/api/error/unauthorized'
require 'email_octopus/api/error/member_email_already_exists_in_list'
require 'byebug'

module EmailOctopus
  # Response object that parses out JSON.
  class API::Response
    delegate :status, :headers, to: :@raw

    def initialize(response)
      @raw = response
      raise error_class, self if error?
    end

    def status
      @raw.status
    end

    def headers
      @raw.headers
    end

    def success?
      @raw.code.to_s[0].to_i < 4
    end

    def error?
      !success?
    end

    def body
      JSON.parse @raw.body
    end

    def error_class
      return unless error?
      case body['error']['code']
      when 'INVALID_PARAMETERS'
        EmailOctopus::API::Error::InvalidParameters
      when 'API_KEY_INVALID'
        EmailOctopus::API::Error::ApiKeyInvalid
      when 'UNAUTHORISED'
        EmailOctopus::API::Error::Unauthorized
      when 'NOT_FOUND'
        EmailOctopus::API::Error::NotFound
      when 'MEMBER_EXISTS_WITH_EMAIL_ADDRESS'
        EmailOctopus::API::Error::MemberEmailAlreadyExistsInList
      else
        byebug
        EmailOctopus::API::Error
      end
    end
  end
end
