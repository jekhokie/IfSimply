class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :title
      t.string :description

      t.references :club

      t.timestamps
    end

    add_index :courses, :club_id
  end
end
