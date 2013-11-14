class AddFileAttachmentToLesson < ActiveRecord::Migration
  def self.up
    add_attachment :lessons, :file_attachment
  end

  def self.down
    remove_attachment :lessons, :file_attachment
  end
end
