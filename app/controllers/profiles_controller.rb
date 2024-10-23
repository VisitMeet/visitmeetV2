class ProfilesController < ApplicationController
  def show
    @user = User.find_by(username: params[:username])

    if @user
      # Render the profile page if user is found
    else
      # Redirect to a 404 page or show an error if user is not found
      render file: "#{Rails.root}/public/404.html", status: :not_found
    end
  end
end