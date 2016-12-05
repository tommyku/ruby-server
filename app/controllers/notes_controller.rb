class NotesController < ApiController

  include PrettyApiHelper

  before_action  {
    if params[:id]
      @note = current_user.notes.find(params[:id])
    end

    @user = current_user
  }

  def create
    @note = current_user.notes.new(s_params)
    if @note.save
      render :json => @note
    else
      not_valid(@note)
    end
  end

  def update
    @note.update!(s_params)
    render :json => @note, :include => :presentation
  end

  def batch_update
    note_hashes = params[:notes]
    Note.transaction do
      Note.where(:user_id => current_user.id).find_each do |note|
        note_hash = note_hashes.detect{|s| s[:id] == note.id}
        if note_hash
          note.update(PrettyApiHelper.with_nested_attributes(note_hash.permit(*permitted_params), :presentation))
        end
      end
    end

    render :json => {:success => true}

  rescue ActiveRecord::RecordInvalid => invalid
    render :json => {:error => "Unable to save.", :success => false}

  end

  def destroy
    @note.destroy
  end

  def share
    if !@note
      # sharing local note, no user
      @note = Note.new(s_params)
    end

    if !@note.presentation
      if @user
        @note.presentation = @user.owned_presentations.new({:presentable => @note})
      else
        @note.presentation = Presentation.new({:presentable => @note})
      end
    end

    if !@note.presentation.root_path
      if Rails.configuration.x.neeto.single_user_mode
        @note.presentation.set_root_path_from_name(@note.name)
      else
        @note.presentation.set_random_root_path
      end
    end

    @note.presentation.enabled = true
    @note.presentation.save

    if @note.save
      render :json => @note, :include => :presentation
    else
      not_valid @note
    end
  end

  def unshare
    @note.presentation.enabled = false
    @note.presentation.save
    if @note.save
      render :json => @note, :include => :presentation
    else
      not_valid @note
    end
  end

  private

  def s_params
    PrettyApiHelper.with_nested_attributes(params.permit(*permitted_params), :presentation)
  end

  def permitted_params
    [:name, :content, :local_encrypted_content, :local_eek,
      :local_encryption_scheme, :group_id, :token, :shared_via_group,
      presentation: [:id, :root_path]]
  end

end
