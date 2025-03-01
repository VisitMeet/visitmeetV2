class ProfilesController < ApplicationController
  def show
    @user = User.find(params[:id])
    @tags = @user.tags
    @existing_tags = Tag.pluck(:name)
  end

  def add_tag
    @user = User.find(params[:id])
    tag = Tag.find_or_create_by(name: params[:tag_name])
    @user.tags << tag unless @user.tags.include?(tag)
    redirect_to profile_path(@user)
  end

  def remove_tag
    @user = User.find(params[:id])
    tag = Tag.find(params[:tag_id])
    if @user.tags.delete(tag)
      head :ok
    else
      head :unprocessable_entity
    end
  end
end
