class UpsellPage < ActiveRecord::Base
  attr_accessible :basic_articles_desc, :basic_courses_desc, :discussion_forums_desc, :exclusive_articles_desc, :heading, :in_depth_courses_desc, :sub_heading

  belongs_to :club

  validates :heading,                 :presence => { :message => "for upsell page can't be blank" }
  validates :sub_heading,             :presence => { :message => "for upsell page can't be blank" }
  validates :basic_articles_desc,     :presence => { :message => "for upsell page can't be blank" }
  validates :exclusive_articles_desc, :presence => { :message => "for upsell page can't be blank" }
  validates :basic_courses_desc,      :presence => { :message => "for upsell page can't be blank" }
  validates :in_depth_courses_desc,   :presence => { :message => "for upsell page can't be blank" }
  validates :discussion_forums_desc,  :presence => { :message => "for upsell page can't be blank" }

  def assign_defaults
    self.heading                 = Settings.upsell_pages[:default_heading]
    self.sub_heading             = Settings.upsell_pages[:default_sub_heading]
    self.basic_articles_desc     = Settings.upsell_pages[:default_basic_articles_desc]
    self.exclusive_articles_desc = Settings.upsell_pages[:default_exclusive_articles_desc]
    self.basic_courses_desc      = Settings.upsell_pages[:default_basic_courses_desc]
    self.in_depth_courses_desc   = Settings.upsell_pages[:default_in_depth_courses_desc]
    self.discussion_forums_desc  = Settings.upsell_pages[:default_discussion_forums_desc]
  end

  def user
    club.user
  end
end
