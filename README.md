# EmailOctopus

An API client for the [EmailOctopus][] email marketing service, allowing
you to create/view/update/destroy campaigns, lists, and contacts.

For more information on how to set up your account, read the [API docs][].

**NOTE:** This project is alpha software, tests are still being written
but most of the logic is there.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "email_octopus", git: "https://github.com/givesafe/email_octopus", branch: :master
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install email_octopus

## Usage

First, configure the `EmailOctopus` library so it can be used with your
account. After obtaining your API key, add the following before your
application is initialized. For Rails apps, this might be
**config/initializers/email_octopus.rb**

```ruby
EmailOctopus.configure do |config|
  config.api_key = 'your-email-octopus-api-key'
end
```

You can now perform CRUD actions on the various resources that the API
provides.

Below is a short summary of what you can do with the library. For more
information, read the [RDoc][] documentation.

### Creating a new list

```ruby
list = EmailOctopus::List.create name: 'Newsletter'
```

### Adding a contact to that list

```ruby
list = EmailOctopus::List.find 'previous-list-id'
contact = EmailOctopus::Contact.create(
  first_name: 'Lester',
  last_name: 'Tester',
  email_address: 'lester.tester@example.com',
  subscribed: true,
  list_id: list.id
)
```


### Getting Contacts for that list

```ruby
list = EmailOctopus::List.find 'previous-list-id'
contacts = list.contacts
```

or you can use Contact.where

```ruby
contacts = EmailOctopus::Contact.where(list_id: 'previous-list-id')
```

### Find a specific user for that list

You cannot find a contact outside of a list.
```ruby
list = EmailOctopus::Contact.where(list_id: 'previous-list-id')
contacts = list.contacts

contact = list.contact.select {|x| x.id == 'previous_contact_id'}
```


You can also initialize a contact and then check if it is persisted.
```ruby
contact = EmailOctopus::Contact.new list_id: 'previous-list-id', id: 'previous-contact-id'
contact.persisted? # if the user exists, the contact variable will update with refreshed attributes
```



### Removing a user from the contact list

```ruby
list = EmailOctopus::Contact.where(list_id: 'previous-list-id')
contacts = list.contacts

contact = list.contact.select {|x| x.id == 'previous_contact_id'}
contact.destroy
```


## Query Compaigns and Lists

### Getting Campaigns

```ruby
# Queries default with page: 1, and limit: 100.
# the maximum limit is 100
campaigns_query = EmailOctopus::Campaign.all(page: 2, limit: 10)

campaigns = campaigns_query.results

# You may change the page or limit settings for the query manually.
campaigns_query.page 3
compaigns_query.limit 100

# Make sure you call #results again after setting page or limit.
next_page_of_campaigns = campaigns_query.results


```

### Getting Lists

```ruby
# Queries default with page: 1, and limit: 100.
# the maximum limit is 100
campaigns_query = EmailOctopus::List.all(page: 2, limit: 10)

campaigns = campaigns_query.results

# You may change the page or limit settings for the query manually.
campaigns_query.page 3
compaigns_query.limit 100

# Make sure you call #results again after setting page or limit.
next_page_of_campaigns = campaigns_query.results


```


## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake test` to run the tests. You can also run `bin/console`
for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

To release a new version, update the version number in `version.rb`, and then
run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tubbo/email_octopus.
This project is intended to be a safe, welcoming space for collaboration, and
contributors are expected to adhere to the [Contributor Covenant][] code of conduct.

## License

The gem is available as open source under the terms of the [MIT License][].

[EmailOctopus]: http://emailoctopus.com
[API docs]: http://emailoctopus.com/api-documentation
[Contributor Covenant]: http://contributor-covenant.org
[MIT License]: http://opensource.org/licenses/MIT
[RDoc]: http://rubydoc.info/github/tubbo/email_octopus/master/frames.html
