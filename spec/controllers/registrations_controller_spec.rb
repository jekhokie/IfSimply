require 'spec_helper'

describe RegistrationsController do
  describe "'after_inactive_signup_path_for'" do
    it "returns the registrations notify path" do
      subject.send(:after_inactive_sign_up_path_for, User.new).should == registration_notify_path
    end
  end
end
