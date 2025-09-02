class ResultsController < ApplicationController
  def index
    tags = params[:tags].to_s.split(',')
    results = SearchService.new(tags).call
    @profiles = results[:users].includes(:tags)
    @offerings = results[:offerings]
    @reviews = results[:reviews]
    @search_tags = tags
  end
end
