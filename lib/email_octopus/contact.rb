# frozen_string_literal: true

module EmailOctopus
  # Contact of a list
  class Contact < Model
    attribute :id
    attribute :list_id
    attribute :fields
    attribute :email_address
    attribute :status
    attribute :created_at

    def self.where(list_id: '')
      api = API.new EmailOctopus.config.api_key
      api.get("/lists/#{list_id}/contacts", {}).body['data'].map do |params|
        new params.merge(list_id: list_id)
      end
    end

    def as_json
      attributes.reject do |(key, _val)|
        %w(id list_id created_at).include? key.to_s
      end.to_h
    end

    def base_path
      "/lists/#{attributes['list_id']}/contacts"
    end

  end
end
