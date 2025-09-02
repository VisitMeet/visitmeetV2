class SearchSuggestionsController < ApplicationController
  def index
    q = params[:q].to_s.strip
    tags = Tag.where("name ILIKE ?", "%#{q}%").limit(5).pluck(:name)
    locations = LocationTag.where("location ILIKE ?", "%#{q}%").limit(5).pluck(:location)
    render json: (tags + locations).uniq.first(10)
  end
end
