class SalesPage < ActiveRecord::Base
  attr_accessible :call_to_action, :heading, :sub_heading, :video

  belongs_to :club

  validates :heading,        :presence => { :message => "for sales page can't be blank" }
  validates :sub_heading,    :presence => { :message => "for sales page can't be blank" }
  validates :call_to_action, :presence => { :message => "for sales page can't be blank" }
  validate  :url_exists

  def assign_defaults
    self.heading        = Settings.sales_pages[:default_heading]
    self.sub_heading    = Settings.sales_pages[:default_sub_heading]
    self.call_to_action = Settings.sales_pages[:default_call_to_action]
  end

  private

  def url_exists
    errors.add(:base, "URL is not reachable or malformed - please check your video URL") unless VideoManipulator.validate_url(video)
  end
end
