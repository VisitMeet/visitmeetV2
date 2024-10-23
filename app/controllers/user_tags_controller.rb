class UserTagsController < ApplicationController
  def add_location_tag
    tag = Tag.find_or_create_by(name: params[:name].downcase)
    location_tag = LocationTag.find_or_create_by(tag: tag)
    current_user.location_tags << location_tag unless current_user.location_tags.include?(location_tag)
    redirect_to profile_path(current_user.username)
  end

  def add_profession_tag
    tag = Tag.find_or_create_by(name: params[:name].downcase)
    profession_tag = ProfessionTag.find_or_create_by(tag: tag)
    current_user.profession_tags << profession_tag unless current_user.profession_tags.include?(profession_tag)
    redirect_to profile_path(current_user.username)
  end
end
