class RemoveUnusedFields < ActiveRecord::Migration
  def change
    remove_column :users, :username
    remove_column :snippets, :token
    remove_column :snippets, :shared

    remove_column :categories, :shared
    remove_column :categories, :shared_name

    remove_column :users, :presentable_id
    remove_column :users, :presentable_type

    remove_column :snippets, :presentable_id
    remove_column :snippets, :presentable_type

    remove_column :categories, :presentable_id
    remove_column :categories, :presentable_type
  end
end
