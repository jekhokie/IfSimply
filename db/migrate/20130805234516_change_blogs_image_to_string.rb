class ChangeBlogsImageToString < ActiveRecord::Migration
  def up
    remove_attachment :blogs, :image
    add_column :blogs, :image, :string

    Blog.all.each{|b| b.update_attributes :image => "/assets/iS_club_thumb.jpg"}
  end

  def down
    remove_column :blogs, :image
    add_attachment :blogs, :image
  end
end
