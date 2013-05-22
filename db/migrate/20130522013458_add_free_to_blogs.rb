class AddFreeToBlogs < ActiveRecord::Migration
  def change
    add_column :blogs, :free, :boolean
  end
end
