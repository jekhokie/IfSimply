class AddLogoToCourses < ActiveRecord::Migration
  def change
    add_attachment :courses, :logo
  end
end
