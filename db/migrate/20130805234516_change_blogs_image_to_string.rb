class ChangeBlogsImageToString < ActiveRecord::Migration
  def up
    remove_attachment :blogs, :image
    add_column :blogs, :image, :string
  end

  def down
    remove_column :blogs, :image
    add_attachment :blogs, :image
  end
end
