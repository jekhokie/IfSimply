require 'spec_helper'

FactoryGirl.factories.map(&:name).each do |factory_name|
  describe "FactoryGirl #{factory_name} factory" do
    before :each do
      FakeWeb.clean_registry
      FakeWeb.register_uri(:head, "http://www.ifsimply.com/",  :body => "", :status => [ "200", "OK" ])
      FakeWeb.register_uri(:head, "http://vimeo.com/22977143", :body => "", :status => [ "200", "OK" ])
    end

    specify { FactoryGirl.build(factory_name).should be_valid }
  end
end
