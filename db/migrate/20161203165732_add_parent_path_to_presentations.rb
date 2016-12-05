class AddParentPathToPresentations < ActiveRecord::Migration[5.0]
  def change
    add_column :presentations, :parent_path, :string, after: :root_path

    Presentation.where("relative_path IS NOT NULL").each do |presentation|
      presentation.parent_path = presentation.owner.presentation.root_path
      presentation.save
    end
  end
end
