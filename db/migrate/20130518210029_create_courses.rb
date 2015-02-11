class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :title
      t.string :description

      t.string :slug

      t.references :club

      t.timestamps
    end

    add_index :courses, :club_id
    add_index :courses, :slug, :unique => true
  end
end
