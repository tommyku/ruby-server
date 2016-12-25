class ItemsController < ApiController

  before_action  {
    if params[:uuid]
      @item = current_user.items.find(params[:uuid])
    end

    @user = current_user
  }

  def index
    if params[:modified_after]
      items = @user.items.where("modified_at > ?", params[:updated_after].to_time)
    else
      items = @user.items
    end

    render :json => {:items => items}
  end

  def create
    item_hashes = params[:items] || [params[:item]]
    items = []

    Item.transaction do
      item_hashes.each do |item_hash|
        item = current_user.items.find_or_create_by(:uuid => item_hash[:uuid])
        item.update(item_hash.permit(*permitted_params))
        if item_hash.has_key?("presentation_name")
          self._update_presentation_name(item, item_hash[:presentation_name])
        end
        items.push(item)
      end
    end

    render :json => {:items => items}

  rescue ActiveRecord::RecordInvalid => invalid
    render :json => {:errors => ["Unable to save."]}
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
    @item.destroy
  end

  private

  def item_params
    params.permit(*permitted_params)
  end

  def permitted_params
    [:content, :enc_item_key, :content_type, :auth_hash]
  end

end
