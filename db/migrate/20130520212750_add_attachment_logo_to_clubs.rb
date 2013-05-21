class AddAttachmentLogoToClubs < ActiveRecord::Migration
  def self.up
    change_table :clubs do |t|
      t.attachment :logo
    end
  end

  def self.down
    drop_attached_file :clubs, :logo
  end
end
