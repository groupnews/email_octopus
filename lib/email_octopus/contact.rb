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
      main_list = current_list = self.all(list_id)
      return main_list if main_list.length < 100

      page = 1
      until current_list.length < 100
        page += 1
        current_list = self.all(list_id, page: page)
        main_list << current_list
      end

      main_list.flatten
    end

    def as_json
      attributes.reject do |(key, _val)|
        %w(id list_id created_at).include? key.to_s
      end.to_h
    end

    def base_path
      "/lists/#{attributes['list_id']}/contacts"
    end

    def self.all(list_id, page: 1, limit: 100)
      _path = "/lists/#{list_id}/contacts"
      query = Query.new(self, page, limit, _path).results do |params|
        params.merge(list_id: list_id)
      end
      query
    end

  end
end
