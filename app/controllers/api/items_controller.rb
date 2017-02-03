class Api::ItemsController < Api::ApiController

  require "standard_file"

  def sync_manager
    if !@sync_manager
      @sync_manager = StandardFile::SyncManager.new(current_user)
    end
    @sync_manager
  end

  def sync
    options = {
      :sync_token => params[:sync_token],
      :cursor_token => params[:cursor_token],
      :limit => params[:limit]
    }
    results = sync_manager.sync(params[:items], options)
    render :json => results
  end

  def destroy
    ids = params[:uuids] || [params[:uuid]]
    sync_manager.destroy_items(ids)
    render :json => {}, :status => 204
  end

end
