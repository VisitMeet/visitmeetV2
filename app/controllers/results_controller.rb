class ResultsController < ApplicationController
  def index
    location = params[:location].to_s.strip.downcase
    profession = params[:profession].to_s.strip.downcase
    
    @profiles = User.includes(:location_tags, :profession_tags)
    
    if location.present?
      @profiles = @profiles.joins(:location_tags).where(location_tags: { location: location })
    end
    
    if profession.present?
      @profiles = @profiles.joins(:profession_tags).where(profession_tags: { profession: profession })
    end
    
    @profiles = @profiles.distinct
    @search_location = location
    @search_profession = profession
  end
end
