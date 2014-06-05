class AddLessonsHeadingToClubs < ActiveRecord::Migration
  def change
    add_column :clubs, :lessons_heading, :string, :default => "Lessons"
  end
end
