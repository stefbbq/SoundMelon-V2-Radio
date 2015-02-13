require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  test "the truth" do
    assert true
  end

  test "should not save without basic info" do
  	# Basic information is email, email_confirmation, and password
  	user = User.new
  	assert !user.save, "Saved the user without basic information"
	end

	test "should not save with mismatched emails" do
		user = User.new(email: "abe@gabe.com", email_confirmation: "abe@gab.com")
		assert !user.save, "Saved the user mismatched emails"
	end

end
