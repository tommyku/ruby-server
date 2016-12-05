class GroupsController < ApiController

  before_action {
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

  def share
    if !@group.presentation
      @group.presentation = @user.owned_presentations.new({:presentable => @group})
    end

    if Rails.configuration.x.neeto.single_user_mode
      @group.presentation.set_root_path_from_name(@group.name) unless @group.presentation.root_path
    else
      @group.presentation.relative_path = @group.name.downcase unless @group.presentation.relative_path
      @group.presentation.parent_path = @user.presentation.root_path
    end

    @group.presentation.enabled = true
    @group.presentation.save!

    @group.notes.each do |note|
      note.shared_via_group = true
      note.save!
    end

    render :json => @group, :include => :presentation
  end

  def unshare
    @group.presentation.enabled = false
    @group.presentation.save!

    @group.notes.each do |note|
      note.shared_via_group = false
      note.save!
    end

    render :json => @group, :include => :presentation
  end

  private

  def c_params
    params.permit(:name)
  end
end
