# app/controllers/users_controller.rb

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :follow, :unfollow]

  def show
    @location_tags            = @user.location_tags
    @profession_tags          = @user.profession_tags
    @existing_location_tags   = LocationTag.pluck(:location)
    @existing_profession_tags = ProfessionTag.pluck(:profession)
    @is_own_profile          = @user == current_user
    @offerings               = @user.offerings.order(created_at: :desc)
    render 'profiles/show'
  end

  def follow
    current_user.follow(@user)
    redirect_to user_path(@user)
  end

  def unfollow
    current_user.unfollow(@user)
    redirect_to user_path(@user)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end