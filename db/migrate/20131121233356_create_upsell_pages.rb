class CreateUpsellPages < ActiveRecord::Migration
  def change
    create_table :upsell_pages do |t|
      t.string :heading
      t.string :sub_heading
      t.string :basic_articles_desc
      t.string :exclusive_articles_desc
      t.string :basic_courses_desc
      t.string :in_depth_courses_desc
      t.string :discussion_forums_desc

      t.references :club

      t.timestamps
    end
  end
end
