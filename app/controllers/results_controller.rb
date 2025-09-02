class ResultsController < ApplicationController
  def index
    tags = params[:tags].to_s.split(',')
    @profiles = SearchService.new(tags).call.includes(:tags)
    @search_tags = tags
  end
end
