class ChangeCoursesLogoToString < ActiveRecord::Migration
  def up
    remove_attachment :courses, :logo
    add_column :courses, :logo, :string

    Course.all.each{|c| c.update_attributes :logo => "/assets/iS_club_thumb.jpg"}
  end

  def down
    remove_column :courses, :logo
    add_attachment :courses, :logo
  end
end
