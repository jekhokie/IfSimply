class ChangeClubLogoToString < ActiveRecord::Migration
  def up
    remove_attachment :clubs, :logo
    change_column :clubs, :logo, :string
  end

  def down
    add_attachment :clubs, :logo
  end
end
