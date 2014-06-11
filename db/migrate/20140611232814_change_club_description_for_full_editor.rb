class ChangeClubDescriptionForFullEditor < ActiveRecord::Migration
  def change
    change_column :clubs, :description, :text, :limit => nil
  end
end
