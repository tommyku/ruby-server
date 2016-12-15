class ReferencesController < ApiController

  before_action  {

    if params[:uuid]
      @reference = Reference.find(params[:uuid])
      if @reference.source_item.user != current_user
        render_unauthorized
        return
      end
    end

    if params[:item_uuid]
      @item = current_user.items.find(params[:item_uuid])
    end

    if params[:refereced_uuid]
      @referenced_item = current_user.items.find(params[:refereced_uuid])
    end

    @user = current_user
  }

  def index
    render :json => @item.references
  end

  def create
    @reference = Reference.new(:source_item => @item, :source_content_type => @item.content_type,
     :referenced_item => @referenced_item, :referenced_content_type => @referenced_item.content_type)
    if @reference.save
      render :json => @reference
    else
      not_valid(@reference)
    end
  end

  def destroy
    @reference.destroy
  end

end
