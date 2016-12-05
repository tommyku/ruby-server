class CreatePresentations < ActiveRecord::Migration
  def change
    create_table :presentations do |t|
      t.string :root_path
      t.string :relative_path

      t.boolean :enabled, :default => true

      t.integer :presentable_id
      t.string :presentable_type

      t.integer :user_id

      t.timestamps null: false
    end

    change_table(:snippets) do |t|
      t.references :presentable, polymorphic: true, index: true
    end

    change_table(:categories) do |t|
      t.references :presentable, polymorphic: true, index: true
    end

    change_table(:users) do |t|
      t.references :presentable, polymorphic: true, index: true
    end

    Snippet.where("token IS NOT NULL").each do |snippet|
      snippet.presentation = snippet.user.owned_presentations.new({:presentable => snippet})
      snippet.presentation.root_path = snippet.token
      snippet.presentation.enabled = true
      snippet.presentation.save
    end

  end
end
