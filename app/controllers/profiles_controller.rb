class ProfilesController < ApplicationController
  def show
    @user = User.find(params[:id])
    @tags = @user.tags
  end

  def add_tag
    @user = User.find(params[:id])
    tag = Tag.find_or_create_by(name: params[:tag_name])
    @user.tags << tag unless @user.tags.include?(tag)
    redirect_to profile_path(@user)
  end
end
