class ResultsController < ApplicationController
  def index
    tags = params[:tags].to_s.split(',').reject(&:blank?)
    results = SearchService.new(tags).call
    @profiles = results.fetch(:users, User.none).includes(:tags)
    @offerings = results.fetch(:offerings, Offering.none)
    @reviews = results.fetch(:reviews, Review.none)
    @search_tags = tags
  end
end
