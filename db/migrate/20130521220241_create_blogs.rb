class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.string :title
      t.text :content, :limit => nil
      t.attachment :image

      t.string :slug

      t.references :club

      t.timestamps
    end

    add_index :blogs, :club_id
    add_index :blogs, :slug, :unique => true
  end
end
