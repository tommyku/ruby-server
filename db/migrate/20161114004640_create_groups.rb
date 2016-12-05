class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.belongs_to :user
      t.string :name
      t.timestamps null: false
    end
  end
end
