# app/controllers/profiles_controller.rb

class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :authorize_user, except: [:show]

  def show
    @location_tags            = @user.location_tags
    @profession_tags          = @user.profession_tags
    @existing_location_tags   = LocationTag.pluck(:location)
    @existing_profession_tags = ProfessionTag.pluck(:profession)
    @is_own_profile          = @user == current_user
    @offerings               = @user.offerings.order(created_at: :desc)
  end

  def add_tag
    tag_name = params[:tag_name].strip.downcase
    tag_type = params[:tag_type]

    if tag_type == 'location'
      tag = LocationTag.find_or_create_by(location: tag_name)
      @user.location_tags << tag unless @user.location_tags.include?(tag)
    elsif tag_type == 'profession'
      tag = ProfessionTag.find_or_create_by(profession: tag_name)
      @user.profession_tags << tag unless @user.profession_tags.include?(tag)
    end

    redirect_to profile_path(@user)
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
      redirect_to profile_url, alert: "Failed to update profile picture."
    end
  end

  private

  def set_user
    # @user = User.find(params[:id])
    @user = current_user
  end
  
  def profile_picture_params
    params.require(:user).permit(:profile_picture)
  end

  def authorize_user
    unless @user == current_user
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end
end