FactoryGirl.define do
  factory :user do
    first_name     "Michael"
		last_name			"Hartl"
		username 			"michaelhartl"
    email    "michael@example.com"
		email_confirmation "michael@example.com"
		password "foobar"
    password_confirmation "foobar"
  end
end
