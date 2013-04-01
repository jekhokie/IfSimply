require 'spec_helper'

FactoryGirl.factories.map(&:name).each do |factory_name|
  describe "FactoryGirl #{factory_name} factory" do
    specify { FactoryGirl.build(factory_name).should be_valid }
  end
end
