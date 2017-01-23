class Api::ItemsController < Api::ApiController

  require "standard_file"

  def sync
    @sync_manager = StandardFile::SyncManager.new(current_user)
    options = {
      :sync_token => params[:sync_token],
      :cursor_token => params[:cursor_token],
      :limit => params[:limit]
    }
    results = @sync_manager.sync(params[:items], options)
    render :json => results
  end

end
