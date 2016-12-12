class RenameFields < ActiveRecord::Migration[5.0]
  def change
    rename_column :notes, :encrypted_content, :enc_content
    rename_column :notes, :encrypted_content_iv, :enc_content_iv

    rename_column :notes, :encrypted_local_encrypted_content, :enc_loc_enc_content
    rename_column :notes, :encrypted_local_encrypted_content_iv, :enc_loc_enc_content_iv

    rename_column :notes, :local_eek, :loc_eek

    remove_column :notes, :encrypted_name
    remove_column :notes, :encrypted_name_iv

    remove_column :notes, :local_encrypted_content
    remove_column :notes, :name
    remove_column :notes, :content
  end
end
