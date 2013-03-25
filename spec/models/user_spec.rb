require 'spec_helper'

describe User do
  before {@user = User.new(first_name: "Example", last_name: "User", email: "user@test.com", username: "adeluser")}
  
  subject {@user}
  
  it {should respond_to(:first_name)}
  it {should respond_to(:last_name)}
	it {should respond_to(:email)}
	it {should respond_to(:username)}
	
	it {should be_valid}
	
	describe "when first_name is not present" do
		before {@user.first_name = " "}
		it {should_not be_valid}
	end
	
	describe "when email is not present" do
		before {@user.email = " "}
		it {should_not be_valid}
	end
	
	describe "when username is not present" do
		before {@user.username = " "}
		it {should_not be_valid}
	end
	
	describe "when first_name is too long" do
		before {@user.first_name = "a"*26}
		it {should_not be_valid}
	end
	
	describe "when last_name is too long" do
		before {@user.last_name = "b"*31}
		it {should_not be_valid}
	end
	
	describe "when email is too long" do
		before {@user.email = "c"*26}
		it {should_not be_valid}
	end
	
	describe "when username is too short" do
		before {@user.username = "d"*7}
		it {should_not be_valid}
	end
	
	describe "when username is too long" do
		before {@user.username = "d"*17}
		it {should_not be_valid}
	end
	
	describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end      
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end      
    end
  end
  
  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end
end
