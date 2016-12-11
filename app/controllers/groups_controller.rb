class GroupsController < ApiController

  before_action {
    # authenticate_request!
    if params[:id]
      @group = current_user.groups.find(params[:id])
    end
    @user = current_user
  }

  def create
    @group = current_user.groups.new(c_params)
    if @group.save!
      render :json => @group
    else
      not_valid(@group)
    end
  end

  def update
    @group.update(c_params)
    @group.save!
    render :json => @group
  end

  def destroy
    @group.destroy
  end

  private

  def c_params
    params.permit(:name)
  end
end
