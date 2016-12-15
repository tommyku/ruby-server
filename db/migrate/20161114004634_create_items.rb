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

    create_table :references, id: false do |t|
      t.string :uuid, limit: 36, primary_key: true, null: false
      t.string :source_uuid
      t.string :source_content_type
      t.string :referenced_uuid
      t.string :referenced_content_type
    end
  end
end
