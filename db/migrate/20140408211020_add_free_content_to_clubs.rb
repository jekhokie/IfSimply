class AddFreeContentToClubs < ActiveRecord::Migration
  def change
    add_column :clubs, :free_content, :boolean, :default => true
  end
end
