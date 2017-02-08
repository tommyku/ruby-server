if ENV["HOST"] && ENV["DROPBOX_CLIENT_ID"] && ENV["DROPBOX_CLIENT_SECRET"]
  DropboxExt.mount_url = ENV["HOST"] + "/ext/dropbox"
  DropboxExt.db_client_id = ENV["DROPBOX_CLIENT_ID"]
  DropboxExt.db_client_secret = ENV["DROPBOX_CLIENT_SECRET"]
end
