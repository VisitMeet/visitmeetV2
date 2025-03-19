class ResultsController < ApplicationController
  def index
    tags = params[:tags].split(',')
    @users = User.joins(:tags).where(tags: { name: tags }).distinct
  end
end
