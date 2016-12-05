class AddHostToPresentation < ActiveRecord::Migration[5.0]
  def change
    change_table(:presentations) do |t|
      t.string :host
    end
  end
end
