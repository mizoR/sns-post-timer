class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username          , null: false, unique: true
      t.string :encrypted_password, null: false
      t.string :salt              , null: false

      t.timestamps
    end
  end
end
