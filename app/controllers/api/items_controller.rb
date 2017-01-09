class Api::ItemsController < Api::ApiController

  before_action  {
    if params[:uuid]
      @item = current_user.items.find(params[:uuid])
    end

    @user = current_user
  }

  def index
    if params[:updated_after]
      items = @user.items.where("updated_at > ?", params[:updated_after].to_time)
    else
      items = @user.items
    end

    render :json => {:items => items}
  end

  def create
    saved_items = _sync_save()
    render :json => {:items => saved_items}
  end

  def sync
    retrieved_items = _sync_get().to_a
    last_updated = DateTime.now
    saved_items, unsaved = _sync_save()
    if saved_items.length > 0
      last_updated = saved_items.sort_by{|m| m.created_at}.first.updated_at
    end

    # manage conflicts
    saved_ids = saved_items.map{|x| x.uuid }
    retrieved_ids = retrieved_items.map{|x| x.uuid }
    conflicts = saved_ids & retrieved_ids # & is the intersection
    # saved items take precedence, retrieved items are duplicated with a new uuid
    conflicts.each do |conflicted_uuid|
      # if changes are greater than 60 seconds apart, create conflicted copy, otherwise discard conflicted
      saved = saved_items.find{|i| i.uuid == conflicted_uuid}
      conflicted = retrieved_items.find{|i| i.uuid == conflicted_uuid}
      if (saved.updated_at - conflicted.updated_at).abs > 60
        dup = conflicted.dup
        dup.user = conflicted.user
        dup.save
        retrieved_items.push(dup)
      end
      retrieved_items.delete(conflicted)
    end

    sync_token = sync_token_from_datetime(last_updated)
    render :json => {:retrieved_items => retrieved_items, :saved_items => saved_items, :unsaved => unsaved, :sync_token => sync_token}
  end

  def sync_token_from_datetime(datetime)
    version = 1
    Base64.encode64("#{version}:" + "#{datetime.to_i}")
  end

  def datetime_from_sync_token(sync_token)
    decoded = Base64.decode64(sync_token)
    parts = decoded.rpartition(":")
    timestamp_string = parts.last
    date = DateTime.strptime(timestamp_string,'%s')
    return date
  end

  def _sync_save
    item_hashes = params[:items] || [params[:item]]
    saved_items = []
    unsaved = []

    item_hashes.each do |item_hash|
      begin
        item = current_user.items.find_or_create_by(:uuid => item_hash[:uuid])
      rescue => error
        unsaved.push({
          :item => item_hash,
          :error => {:message => error.message, :tag => "uuid_conflict"}
          })
        next
      end

      item.update(item_hash.permit(*permitted_params))
      if item_hash.has_key?("presentation_name")
        self._update_presentation_name(item, item_hash[:presentation_name])
      end

      if item.deleted == true
        item.set_deleted
        item.save
      end

      saved_items.push(item)
    end

    return saved_items, unsaved
  end

  def _sync_get
    if params[:sync_token]
      date = datetime_from_sync_token(params[:sync_token])
      items = @user.items.where("updated_at > ?", date).all
    else
      items = @user.items.all
    end

    return items
  end

  def _update_presentation_name(item, pname)
    if pname == "_auto_"
      if !current_user.username
        # assign temporary username
        current_user.set_random_username
        current_user.save
        return
      end
      item.presentation_name = item.slug_for_property_and_name("presentation_name", item.value_for_content_key("title"))
    else
      item.presentation_name = pname
    end
    item.save
  end

  def update
    @item.update!(item_params)
    render :json => @item
  end

  def destroy
    @item.set_deleted
    @item.save
  end

  private

  def item_params
    params.permit(*permitted_params)
  end

  def permitted_params
    [:content, :enc_item_key, :content_type, :auth_hash, :deleted, :created_at]
  end

end
