require 'spec_helper'

describe User do
  it "can be instantiated" do
    User.new.should be_an_instance_of(User)
  end

  describe "name" do
    it "should require a name" do
      FactoryGirl.build(:user, :name => "").should_not be_valid
    end

    it "should reject duplicate names" do
      user = FactoryGirl.create :user
      FactoryGirl.build(:user, :name => user.name).should_not be_valid
    end
  end

  describe "email addresses" do
    it "should require an email address" do
      FactoryGirl.build(:user, :email => "").should_not be_valid
    end

    it "should accept valid email addresses" do
      addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
      addresses.each do |address|
        FactoryGirl.build(:user, :email => address).should be_valid
      end
    end

    it "should reject invalid email addresses" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
      addresses.each do |address|
        FactoryGirl.build(:user, :email => address).should_not be_valid
      end
    end

    it "should reject duplicate email addresses" do
      user = FactoryGirl.create :user
      FactoryGirl.build(:user, :email => user.email).should_not be_valid
    end

    it "should reject email addresses identical up to case" do
      user = FactoryGirl.create :user
      FactoryGirl.build(:user, :email => user.email.upcase).should_not be_valid
    end
  end

  describe "passwords" do
    before(:each) do
      @user = FactoryGirl.create :user
    end

    it "should have a password attribute" do
      @user.should respond_to(:password)
    end

    it "should have a password confirmation attribute" do
      @user.should respond_to(:password_confirmation)
    end
  end

  describe "password validations" do
    it "should require a password" do
      FactoryGirl.build(:user, :password => "", :password_confirmation => "").should_not be_valid
    end

    it "should require a matching password confirmation" do
      FactoryGirl.build(:user, :password_confirmation => "something_else").should_not be_valid
    end

    it "should reject short passwords" do
      FactoryGirl.build(:user, :password => "abc", :password_confirmation => "abc").should_not be_valid
    end
  end

  describe "password encryption" do
    before(:each) do
      @user = FactoryGirl.create :user
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password attribute" do
      @user.encrypted_password.should_not be_blank
    end
  end

  describe "club" do
    before :each do
      @user = FactoryGirl.create :user_with_club
    end

    it "should be destroyed when the user is destroyed" do
      expect { @user.destroy }.to change(Club, :count).by(-1)
    end
  end

  describe "confirm registration" do
    it "should create a club" do
      expect { FactoryGirl.create(:user) }.to change(Club, :count).by(+1)
    end
  end
end
