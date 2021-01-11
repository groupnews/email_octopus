module EmailOctopus
  class Campaign < Model
    attribute :id
    attribute :status
    attribute :name
    attribute :subject
    attribute :to
    attribute :from
    attribute :content
    attribute :created_at
    attribute :sent_at

    # Current version does not support Create or Updating Campaigns with the API
    def save
      false
    end
  end
end
