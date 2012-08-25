class CreateReserves < ActiveRecord::Migration
  def change
    create_table :reserves do |t|
      t.integer :authentication_id, null: false
      t.integer :feed_id          , null: false
      t.datetime :reserved_at     , null: false
      t.datetime :posts_at        , null: true , default: nil

      t.timestamps
    end
  end
end
