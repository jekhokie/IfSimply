class SalesPage < ActiveRecord::Base
  attr_accessible :call_to_action, :heading, :sub_heading

  belongs_to :club

  validates :heading,        :presence => { :message => "for sales page can't be blank" }
  validates :sub_heading,    :presence => { :message => "for sales page can't be blank" }
  validates :call_to_action, :presence => { :message => "for sales page can't be blank" }

  def assign_defaults
    self.heading        = Settings.sales_pages[:default_heading]
    self.sub_heading    = Settings.sales_pages[:default_sub_heading]
    self.call_to_action = Settings.sales_pages[:default_call_to_action]
  end
end
