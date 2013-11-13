require 'spec_helper'

describe RegistrationsController do
  describe "'after_inactive_signup_path_for'" do
    it "returns the registrations notify path" do
      subject.send(:after_inactive_sign_up_path_for, User.new).should == registration_notify_path
    end
  end

  describe "POST 'create'" do
    let(:new_email) { "test@test.com" }

    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end

    it "updates the users count" do
      lambda{ post('create', :policy_agree => "true", :user => { :name                  => "Test",
                                                                 :email                 => "test@test.com",
                                                                 :password              => "someb0gusp4ss",
                                                                 :password_confirmation => "someb0gusp4ss" }) }.should change(User, :count).by(+1)
    end

    describe "for valid attributes" do
      before :each do
        post 'create', :policy_agree => "true", :user => { :name                  => "Test",
                                                           :email                 => "test@test.com",
                                                           :password              => "someb0gusp4ss",
                                                           :password_confirmation => "someb0gusp4ss" }
      end

      it "returns http redirect" do
        response.should be_redirect
      end

      it "redirects to the registration_notify path" do
        response.should redirect_to(registration_notify_path)
      end

      it "returns the user" do
        assigns(:user).should_not be_blank
      end
    end

    describe "for invalid attributes" do
      describe "when a parameter is blank" do
        before :each do
          post 'create', :format => :js, :policy_agree => "true", :user => { :name                  => "",
                                                                             :email                 => "test@test.com",
                                                                             :password              => "someb0gusp4ss",
                                                                             :password_confirmation => "somes" }
        end

        it "returns http success" do
          response.should be_success
        end

        it "returns the user" do
          assigns(:user).should_not be_nil
        end

        it "returns an unsaved user" do
          assigns(:user).should be_new_record
        end

        it "returns a user with an error" do
          assigns(:user).errors.should include(:name)
        end
      end

      describe "when the passwords do not match" do
        before :each do
          post 'create', :format => :js, :policy_agree => "true", :user => { :name                  => "Test",
                                                                             :email                 => "test@test.com",
                                                                             :password              => "someb0gusp4ss",
                                                                             :password_confirmation => "somes" }
        end

        it "returns http success" do
          response.should be_success
        end

        it "returns the user" do
          assigns(:user).should_not be_nil
        end

        it "returns an unsaved user" do
          assigns(:user).should be_new_record
        end

        it "returns a user with an error" do
          assigns(:user).errors.should include(:password)
        end
      end

      describe "when the email address is already taken" do
        let!(:existing_user) { FactoryGirl.create :user, :email => "test@test.com" }

        before :each do
          post 'create', :format => :js, :policy_agree => "true", :user => { :name                  => "Test",
                                                                             :email                 => "test@test.com",
                                                                             :password              => "someb0gusp4ss",
                                                                             :password_confirmation => "someb0gusp4ss" }
        end

        it "returns http success" do
          response.should be_success
        end

        it "returns the user" do
          assigns(:user).should_not be_nil
        end

        it "returns an unsaved user" do
          assigns(:user).should be_new_record
        end

        it "returns a user with an error" do
          assigns(:user).errors.should include(:email)
        end
      end

      describe "when the user does not agree to the terms and conditions" do
        before :each do
          post 'create', :format => :js, :user => { :name                  => "Test",
                                                    :email                 => "test@test.com",
                                                    :password              => "someb0gusp4ss",
                                                    :password_confirmation => "someb0gusp4ss" }
        end

        it "returns http success" do
          response.should be_success
        end

        it "returns the user" do
          assigns(:user).should_not be_nil
        end

        it "returns an unsaved user" do
          assigns(:user).should be_new_record
        end

        it "returns a flash alert" do
          flash[:alert].should_not be_blank
        end
      end
    end
  end
end
