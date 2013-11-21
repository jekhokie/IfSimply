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
end
