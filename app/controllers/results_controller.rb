class ResultsController < ApplicationController
  def index
    tags = params[:tags].to_s.split(',').reject(&:blank?)
    begin
      results = SearchService.new(tags).call
    rescue StandardError => e
      Rollbar.error(e, search_tags: tags) if defined?(Rollbar)
      Rails.logger.error("Search failure: #{e.class} - #{e.message}")
      results = { users: [], offerings: [], reviews: [] }
    end

    users = results[:users]
    @profiles = users.respond_to?(:includes) ? users.includes(:tags) : Array(users)
    @offerings = Array(results[:offerings])
    @reviews   = Array(results[:reviews])
    @search_tags = tags
  end
end
