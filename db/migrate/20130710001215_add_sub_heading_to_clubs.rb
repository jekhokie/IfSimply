class AddSubHeadingToClubs < ActiveRecord::Migration
  def change
    add_column :clubs, :sub_heading, :string, :default => Settings.clubs[:default_sub_heading]
  end
end
