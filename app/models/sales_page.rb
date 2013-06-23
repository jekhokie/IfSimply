class SalesPage < ActiveRecord::Base
  attr_accessible :benefit1, :benefit2, :benefit3, :call_to_action, :heading, :sub_heading, :video

  belongs_to :club

  validates :benefit1,       :presence => { :message => "for sales page can't be blank" }
  validates :benefit2,       :presence => { :message => "for sales page can't be blank" }
  validates :benefit3,       :presence => { :message => "for sales page can't be blank" }
  validates :call_to_action, :presence => { :message => "for sales page can't be blank" }
  validates :heading,        :presence => { :message => "for sales page can't be blank" }
  validates :sub_heading,    :presence => { :message => "for sales page can't be blank" }
  validate  :url_exists

  def assign_defaults
    self.benefit1       = Settings.sales_pages[:default_benefit1]
    self.benefit2       = Settings.sales_pages[:default_benefit2]
    self.benefit3       = Settings.sales_pages[:default_benefit3]
    self.call_to_action = Settings.sales_pages[:default_call_to_action]
    self.heading        = Settings.sales_pages[:default_heading]
    self.sub_heading    = Settings.sales_pages[:default_sub_heading]
  end

  def user
    club.user
  end

  private

  def url_exists
    unless video.blank?
      errors.add(:base, "URL is not reachable or malformed - please check your video URL") unless VideoManipulator.validate_url(video)
    end
  end
end
