class CreateItems < ActiveRecord::Migration
  def change
    create_table :items, id: false do |t|
      t.string :uuid, limit: 36, primary_key: true, null: false
      t.text :content
      t.string :content_type
      t.string :loc_eek
      t.belongs_to :user
      t.timestamps null: false
    end
  end
end
