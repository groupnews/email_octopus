require 'test_helper'

class EmailOctopusTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::EmailOctopus::VERSION
  end

  def test_it_can_get_lists
    EmailOctopus::List.all.first
    assert true
  end

  def test_it_can_get_a_list_details
    assert true
  end

  def test_it_can_create_contacts
    # EmailOctopus::Contact.create(list_id:ENV['TEST_LIST_ID'], email_address: 'test@test.com')
    list = EmailOctopus::List.find(ENV['TEST_LIST_ID'])
    # list.contacts
    list.create_contact(email_address: "test@test.com")
    assert true
  end

end
