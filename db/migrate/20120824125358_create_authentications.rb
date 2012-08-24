class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.integer :user_id    , null: false
      t.string :service_type, null: false
      t.string :uid         , null: false
      t.string :access_token, null: false
      t.datetime :expires_at

      t.timestamps
    end
    add_index :authentications, [:service_type, :uid], unique: true
    add_index :authentications, [:service_type, :access_token], unique: true
  end
end
