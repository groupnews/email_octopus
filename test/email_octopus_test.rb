require 'test_helper'

class EmailOctopusTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::EmailOctopus::VERSION
  end

  def test_it_can_get_lists
    assert true
  end

  def test_it_can_get_a_list_details
    assert true
  end

  def test_it_can_create_contacts
    EmailOctopus::List.find(ENV['TEST_LIST_ID']).create_contact(email_address: "test@test.com")
    assert true
  end

end
