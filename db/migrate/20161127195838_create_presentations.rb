class CreatePresentations < ActiveRecord::Migration
  def change
    create_table :presentations, :id => false do |t|
      t.string :uuid, limit: 36, primary_key: true, null: false

      t.string :root_path
      t.string :parent_path
      t.string :relative_path
      t.string :host

      t.boolean :enabled, :default => true

      t.integer :item_uuid
      t.integer :user_uuid

      t.timestamps null: false
    end
  end
end
