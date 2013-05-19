class AddFreeToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :free, :boolean
  end
end
