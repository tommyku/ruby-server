class UsersController < ApiController

  before_action {
    @user = current_user
    if !@user
      render_unauthorized
    end
  }

  # merge local data with account data
  def merge
    notes = params[:notes]
    notes.each do |s|
      note_params = s.permit(:name, :content)
      note = @user.notes.new(note_params)
      group_name = s[:group_name]
      if group_name
        group = @user.groups.where(:name => group_name).first
        if !group
          group = @user.groups.create({:name => group_name})
        end
      end
      note.group = group
      note.save
    end
  end

  def import
    groups = params[:data][:groups]
    notes = params[:data][:notes]
    presentations = params[:data][:presentations]

    group_mappings = []
    note_mappings = []

    groups.each do |json_group|
      group = current_user.groups.find_or_create_by(uuid: json_group[:uuid])
      group.update(json_group.permit(:uuid, :name, :created_at, :modified_at))
      group.save
      group_mappings.push({:json => json_group, :saved => group})
    end

    notes.each do |json_note|
      if json_note[:group_id]
        group = group_mappings.find {|mapping| mapping[:json][:id] == json_note[:group_id]}[:saved]
        json_note[:group_id] = group.id
      end
      note = current_user.notes.find_or_create_by(uuid: json_note[:uuid])
      note.update(json_note.permit(:uuid, :loc_eek, :content, :group_id, :created_at, :modified_at))
      note.save!
      note_mappings.push({:json => json_note, :saved => note})
    end

    presentations.each do |json_presentation|
      if json_presentation[:presentable_type] == "Note"
        note = note_mappings.find {|mapping| mapping[:json][:id] == json_presentation[:presentable_id]}[:saved]
        json_presentation[:presentable_id] = note.id
      elsif json_presentation[:presentable_type] == "Group"
        group = group_mappings.find {|mapping| mapping[:json][:id] == json_presentation[:presentable_id]}[:saved]
        json_presentation[:presentable_id] = group.id
      end

      presentation = current_user.owned_presentations.find_or_create_by(uuid: json_presentation[:uuid])
      presentation.update(json_presentation.permit(:uuid, :host, :root_path, :relative_path, :presentable_id, :presentable_type, :enabled, :created_at, :modified_at))
      presentation.save
    end
  end

  def current
    render :json => @user, include: [
      :presentation,
      {:groups => {:include => [:presentation]}},
      {:notes => {:include => [:presentation]}}
    ]
  end

  def update
    @user.update(u_params)
    render :json => @user
  end

  def enable_encryption
    @user.local_encryption_enabled = true
    @user.save
    render :json => @user
  end

  def disable_encryption
    @user.local_encryption_enabled = false
    @user.save
    render :json => @user
  end

  def set_username
    if !@user.presentation
      @user.presentation = @user.owned_presentations.new({:presentable => @user})
    end
    @user.presentation.root_path = params[:username]
    @user.presentation.enabled = false
    @user.presentation.save
    render :json => @user.presentation
  end

  private
  def u_params
    params.permit(:username)
  end
end
