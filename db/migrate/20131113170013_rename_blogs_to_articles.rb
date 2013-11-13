class RenameBlogsToArticles < ActiveRecord::Migration
  def change
    rename_table :blogs, :articles
  end
end
