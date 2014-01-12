class SalesPage < ActiveRecord::Base
  attr_accessible :benefit1, :benefit2, :benefit3, :call_to_action, :call_details,
                  :heading, :sub_heading, :video, :details, :about_owner

  belongs_to :club

  validates :benefit1,       :presence => { :message => "for sales page can't be blank" }
  validates :benefit2,       :presence => { :message => "for sales page can't be blank" }
  validates :benefit3,       :presence => { :message => "for sales page can't be blank" }
  validates :details,        :presence => { :message => "for sales page can't be blank" }
  validates :call_to_action, :presence => { :message => "for sales page can't be blank" }
  validates :call_details,   :presence => { :message => "for sales page can't be blank" }
  validates :heading,        :presence => { :message => "for sales page can't be blank" }
  validates :sub_heading,    :presence => { :message => "for sales page can't be blank" }
  validates :about_owner,    :presence => { :message => "for sales page can't be blank" }
  validate  :url_exists
  validate  :url_exists

  validates_format_of :video, :with        => /.*(youtube|youtu.be|vimeo|slideshare).*/,
                              :message     => "must be a YouTube video, Vimeo Video, or Slideshare Presentation",
                              :allow_blank => true

  def assign_defaults
    self.benefit1       = Settings.sales_pages[:default_benefit1]
    self.benefit2       = Settings.sales_pages[:default_benefit2]
    self.benefit3       = Settings.sales_pages[:default_benefit3]
    self.details        = Settings.sales_pages[:default_details]
    self.call_to_action = Settings.sales_pages[:default_call_to_action]
    self.call_details   = Settings.sales_pages[:default_call_details]
    self.heading        = Settings.sales_pages[:default_heading]
    self.sub_heading    = Settings.sales_pages[:default_sub_heading]
    self.video          = Settings.sales_pages[:default_video]
    self.about_owner    = Settings.sales_pages[:default_about_owner]
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
