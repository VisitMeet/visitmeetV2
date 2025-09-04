class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def show
    @location_tags            = @user.location_tags
    @profession_tags          = @user.profession_tags
    @existing_location_tags   = LocationTag.pluck(:location)
    @existing_profession_tags = ProfessionTag.pluck(:profession)
    @is_own_profile          = true
    @offerings               = @user.offerings.order(created_at: :desc)
  end

  def add_tag
    tag_name = params[:tag_name].to_s.strip.downcase
    tag_type = params[:tag_type]

    return redirect_to(profile_path, alert: 'Tag name cannot be blank.') if tag_name.blank?

    if tag_type == 'location'
      tag = LocationTag.find_or_create_by(location: tag_name)
      @user.location_tags << tag unless @user.location_tags.include?(tag)
    elsif tag_type == 'profession'
      tag = ProfessionTag.find_or_create_by(profession: tag_name)
      @user.profession_tags << tag unless @user.profession_tags.include?(tag)
    end

    redirect_to profile_path
  end

  def remove_tag
    tag_type = params[:tag_type]
    tag_id   = params[:tag_id]

    if tag_type == 'location'
      tag = LocationTag.find_by(id: tag_id)
      @user.location_tags.delete(tag) if tag
    elsif tag_type == 'profession'
      tag = ProfessionTag.find_by(id: tag_id)
      @user.profession_tags.delete(tag) if tag
    end

    head :ok
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
    permitted = [:country, :bio]
    permitted &= User.column_names.map(&:to_sym)
    params.require(:user).permit(*permitted)
  end
end