class ResultsController < ApplicationController
  def index
    tags = []
    tags += params[:tags].is_a?(Array) ? params[:tags] : params[:tags].to_s.split(',')
    tags << params[:location] if params[:location].present?
    tags << params[:profession] if params[:profession].present?
    tags.map! { |t| t.to_s.strip.downcase }.reject!(&:blank?)

    @profiles = User.includes(:location_tags, :profession_tags)
                   .search_by_tags(tags)
                   .distinct

    @search_tags = tags
  end
end
