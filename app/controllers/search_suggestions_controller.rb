class SearchSuggestionsController < ApplicationController
  def index
    q = params[:q].to_s.strip.downcase
    if q.blank?
      return render json: { error: 'q parameter is required' }, status: :bad_request
    end

    suggestions = Rails.cache.fetch(["search_suggestions", q], expires_in: 1.hour) do
      {
        tags: Tag.where("name ILIKE ?", "%#{q}%").order(:name).limit(5).pluck(:name),
        locations: LocationTag.where("location ILIKE ?", "%#{q}%").order(:location).limit(5).pluck(:location)
      }
    end

    render json: suggestions
  end
end
