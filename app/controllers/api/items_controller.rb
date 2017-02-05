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
    post_to_extensions(params.to_unsafe_hash[:items])
    render :json => results
  end

  def post_to_extensions(items)
    if !items || items.length == 0
      return
    end

    extensions = current_user.items.where(:content_type => "SF|Extension")
    extensions.each do |ext|
      url = url_for_extension(ext)
      post_to_extension(url, items)
    end
  end

  def post_to_extension(url, items)
    if url && url.length > 0
      ExtensionJob.perform_later(url, items)
    end
  end

  # Writes all user data to backup extension.
  # This is called when a new extension is registered.
  def backup
    ext = current_user.items.find(params[:uuid])
    url = url_for_extension(ext)
    items = current_user.items.to_a
    if items && items.length > 0
      post_to_extension(url, items)
    end
  end


  ##
  ## REST API
  ##

  def create
    item = current_user.items.new(params[:item].permit(*permitted_params))
    item.save
    render :json => {:item => item}
  end

  def destroy
    ids = params[:uuids] || [params[:uuid]]
    sync_manager.destroy_items(ids)
    render :json => {}, :status => 204
  end

  private

  def url_for_extension(ext)
    string = ext.content[3..ext.content.length]
    decoded = Base64.decode64(string)
    obj = JSON.parse(decoded)
    url = obj["url"]
    return url
  end

  def permitted_params
    [:content_type, :content, :auth_hash, :enc_item_key]
  end

end
