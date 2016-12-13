class NotesController < ApiController

  before_action  {
    if params[:id]
      @note = current_user.notes.find(params[:id])
    end

    @user = current_user
  }

  def index
    if params[:modified_after]
      notes = @user.notes.where("modified_at > ?", params[:modified_after].to_time)
    else
      notes = @user.notes
    end

    render :json => notes
  end

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
          note.update(note_hash.permit(*permitted_params))
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

  private

  def s_params
    params.permit(*permitted_params)
  end

  def permitted_params
    [:content, :loc_eek, :local_encryption_scheme, :group_id, :token]
  end

end
