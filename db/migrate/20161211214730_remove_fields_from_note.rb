class RemoveFieldsFromNote < ActiveRecord::Migration[5.0]
  def change
    remove_column :notes, :enc_loc_enc_content
    remove_column :notes, :enc_loc_enc_content_iv
    remove_column :notes, :loc_enc_content
  end
end
