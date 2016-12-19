class CreateItems < ActiveRecord::Migration
  def change
    create_table :items, id: false do |t|
      t.string :uuid, limit: 36, primary_key: true, null: false
      t.text :content
      t.string :content_type
      t.string :enc_item_key
      t.string :auth_hash
      t.string :user_uuid

      t.string :presentation_name

      t.timestamps null: false
    end
  end
end
