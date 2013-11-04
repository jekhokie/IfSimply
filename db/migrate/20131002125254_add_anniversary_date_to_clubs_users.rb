class AddAnniversaryDateToClubsUsers < ActiveRecord::Migration
  def change
    add_column :clubs_users, :anniversary_date, :date
  end
end
