class Topic < ActiveRecord::Base
  attr_accessible :description, :subject

  validates :subject,     :presence => { :message => "for topic can't be blank" }
  validates :description, :presence => { :message => "for topic can't be blank" }

  belongs_to :discussion_board

  def user
    discussion_board.user
  end
end
