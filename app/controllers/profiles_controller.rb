class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def show
    @location_tags            = @user.location_tags
    @profession_tags          = @user.profession_tags
    @existing_location_tags   = LocationTag.pluck(:location)
    @existing_profession_tags = ProfessionTag.pluck(:profession)
    @is_own_profile           = true
    @offerings                = @user.offerings.order(created_at: :desc)
  end

  def add_tag
    tag_name = params[:tag_name].to_s.strip.downcase
    tag_type = params[:tag_type]

    return redirect_to(profile_path, alert: 'Tag name cannot be blank.') if tag_name.blank?

    case tag_type
    when 'location'
      tag = LocationTag.find_or_create_by(location: tag_name)
      @user.location_tags << tag unless @user.location_tags.include?(tag)
    when 'profession'
      tag = ProfessionTag.find_or_create_by(profession: tag_name)
      @user.profession_tags << tag unless @user.profession_tags.include?(tag)
    when 'interest'
      tag = Tag.find_or_create_by(name: tag_name)
      @user.tags << tag unless @user.tags.include?(tag)
    end

    redirect_to profile_path
  end

  def remove_tag
    tag_type = params[:tag_type]
    tag_id   = params[:tag_id]

    case tag_type
    when 'location'
      tag = LocationTag.find_by(id: tag_id)
      @user.location_tags.delete(tag) if tag
    when 'profession'
      tag = ProfessionTag.find_by(id: tag_id)
      @user.profession_tags.delete(tag) if tag
    when 'interest'
      tag = Tag.find_by(id: tag_id)
      @user.tags.delete(tag) if tag
    end

    head :ok
  end

  def add_photo
    photos = profile_params[:photos]
    current_user.photos.attach(photos) if photos
    redirect_to profile_path
  end

  def remove_photo
    photo = current_user.photos.find_by(id: params[:photo_id])
    photo.purge if photo
    redirect_to profile_path
  end

  def update_picture
    if current_user.update(profile_picture_params)
      redirect_to profile_path, notice: "Profile picture updated successfully."
    else
      redirect_to profile_path, alert: "Failed to update profile picture."
    end
  end

  def update
    if current_user.update(profile_params)
      redirect_to profile_path, notice: "Profile updated successfully."
    else
      redirect_to profile_path, alert: "Failed to update profile."
    end
  end

  private

  def set_user
    @user = current_user
  end
  
  def profile_picture_params
    params.require(:user).permit(:profile_picture)
  end

  def profile_params
    permitted = [:country, :bio, :languages, :hosting_available]
    permitted &= User.column_names.map(&:to_sym)
    params.require(:user).permit(*permitted, photos: [])
  end
end