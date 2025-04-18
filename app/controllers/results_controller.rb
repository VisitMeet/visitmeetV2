class ResultsController < ApplicationController
  def index
    tags = params[:tags].to_s.split(',').map(&:strip)
    @profiles = User.joins(:tags).where(tags: { name: tags }).distinct
  end
end
