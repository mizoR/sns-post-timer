class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.integer :user_id, null: false
      t.string :message, null: false
      t.string :picture
      t.string :link
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
