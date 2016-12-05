class CreatePresentations < ActiveRecord::Migration
  def change
    create_table :presentations do |t|
      t.string :root_path
      t.string :parent_path
      t.string :relative_path
      t.string :host

      t.boolean :enabled, :default => true

      t.integer :presentable_id
      t.string :presentable_type

      t.integer :user_id

      t.timestamps null: false
    end
  end
end
