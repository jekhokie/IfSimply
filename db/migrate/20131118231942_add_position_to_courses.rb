class AddPositionToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :position, :integer
  end
end
