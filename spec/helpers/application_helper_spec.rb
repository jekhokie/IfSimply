require 'spec_helper'

describe ApplicationHelper do
  describe "flash_class" do
    it { flash_class(:notice).should  == "alert alert-info"    }
    it { flash_class(:success).should == "alert alert-success" }
    it { flash_class(:error).should   == "alert alert-error"   }
    it { flash_class(:alert).should   == "alert alert-error"   }
  end

  describe "resource_name" do
    it { resource_name.should == :user }
  end

  describe "resource_class" do
    before :each do
      @devise_mapping = Devise.mappings[:user]
    end

    it { resource_class.should == User }
  end

  describe "resource" do
    it { resource.should be_instance_of(User) }
  end

  describe "devise_mapping" do
    it { devise_mapping.should == Devise.mappings[:user] }
  end
end
