require 'spec_helper'

describe ConfirmationsController do
  describe "GET 'show'" do
    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end

    describe "for description" do
      it "assigns a description if none exists" do
        user = FactoryGirl.create :user, :description => nil

        get 'show', { :confirmation_token => user.confirmation_token }

        user.reload
        user.description.should_not be_blank
        user.description.should == Settings.users[:default_description]
      end

      it "does not change the description if one already exists" do
        original_description = "Bogus Description"
        user = FactoryGirl.create :user, :description => original_description

        get 'show', { :confirmation_token => user.confirmation_token }

        user.reload
        user.description.should_not be_blank
        user.description.should == original_description
      end
    end

    describe "for icon" do
      it "assigns an icon if none exists" do
        user = FactoryGirl.create :user, :icon => nil

        get 'show', { :confirmation_token => user.confirmation_token }

        user.reload
        user.icon.should_not be_blank
        user.icon.should == Settings.users[:default_icon]
      end

      it "does not change the icon if one already exists" do
        original_icon = "bogus_icon.jpg"
        user = FactoryGirl.create :user, :icon => original_icon

        get 'show', { :confirmation_token => user.confirmation_token }

        user.reload
        user.icon.should_not be_blank
        user.icon.should == original_icon
      end
    end
  end
end
