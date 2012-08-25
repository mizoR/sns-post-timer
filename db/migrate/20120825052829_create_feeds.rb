class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :message
      t.string :picture
      t.string :link
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
