class ChangeCourseDescriptionForFullEditor < ActiveRecord::Migration
  def change
    change_column :courses, :description, :text, :limit => nil
  end
end
