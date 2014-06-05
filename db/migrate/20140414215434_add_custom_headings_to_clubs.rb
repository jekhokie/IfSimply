class AddCustomHeadingsToClubs < ActiveRecord::Migration
  def change
    add_column :clubs, :courses_heading,     :string, :default => "Courses"
    add_column :clubs, :articles_heading,    :string, :default => "Articles"
    add_column :clubs, :discussions_heading, :string, :default => "Discussions"
  end
end
