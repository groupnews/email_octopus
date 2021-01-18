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

      self.all_pages(list_id)
    end

    def as_json
      attributes.reject do |(key, _val)|
        %w(id list_id created_at).include? key.to_s
      end.to_h
    end

    def base_path
      "/lists/#{attributes['list_id']}/contacts"
    end

    # if we update query.rb to be able to use parent dependency for certain classes
    # then we could manage all of this is Query.
    #
    # This new method adds value to all Model objects in the case that you HAVE
    # to receive the full list.
    def self.all_pages(list_id)
      main_list = current_list = all(list_id)
      return main_list if main_list.length < 100

      page = 1
      until current_list.length < 100
        page += 1
        current_list = all(list_id, page: page)
        main_list << current_list
      end

      main_list.flatten
    end

    # This is the original .all which maybe that one
    def self.all(list_id, page: 1, limit: 100)
      "/lists/#{list_id}/contacts?page=#{page}&limit=#{limit}"

      api.get(contacts_url(page: page, limit: limit), {}).body['data'].map do |params|
        new params.merge(list_id: list_id)
      end
    end

  end
end
