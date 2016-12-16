class ItemsController < ApiController

  before_action  {
    if params[:uuid]
      @item = current_user.items.find(params[:uuid])
    end

    @user = current_user
  }

  def index
    if params[:modified_after]
      items = @user.items.where("modified_at > ?", params[:modified_after].to_time)
    else
      items = @user.items
    end

    render :json => items
  end

  def create
    item_hashes = params[:items] || [params[:item]]
    items = []

    Item.transaction do
      item_hashes.each do |item_hash|
        item = current_user.items.find_or_create_by(:uuid => item_hash[:uuid])
        item.update(item_hash.permit(*permitted_params))
        items.push(item)
      end
    end

    render :json => {:items => items}

  rescue ActiveRecord::RecordInvalid => invalid
    render :json => {:errors => ["Unable to save."]}
  end

  def update
    @item.update!(item_params)
    render :json => @item, :include => :presentation
  end

  def destroy
    @item.destroy
  end

  # def batch_update
  #   item_hashes = params[:items]
  #   Item.transaction do
  #     Item.where(:user_id => current_user.id).find_each do |item|
  #       item_hash = item_hashes.detect{|s| s[:uuid] == item.id}
  #       if item_hash
  #         item.update(item_hash.permit(*permitted_params))
  #       end
  #     end
  #   end
  #
  #   render :json => {:success => true}
  #
  # rescue ActiveRecord::RecordInvalid => invalid
  #   render :json => {:error => "Unable to save.", :success => false}
  # end

  def destroy
    @item.destroy
  end

  private

  def item_params
    params.permit(*permitted_params)
  end

  def permitted_params
    [:content, :loc_eek, :content_type]
  end

end
