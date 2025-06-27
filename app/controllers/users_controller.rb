# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def show
    @location_tags = @user.location_tags
    @profession_tags = @user.profession_tags
    @is_own_profile = (@user == current_user)
    @offerings = @user.offerings.order(created_at: :desc)
    @user = User.find(params[:id])
    render "profiles/show"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end