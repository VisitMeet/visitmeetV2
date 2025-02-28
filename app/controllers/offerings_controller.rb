class OfferingsController < ApplicationController
  before_action :authenticate_user! # Assuming Devise

  def new
    @offering = Offering.new
  end

  def create
    @offering = current_user.offerings.build(offering_params)
    if @offering.save
      redirect_to user_path(current_user), notice: "Offering created!"
    else
      render :new
    end
  end

  private

  def offering_params
    params.require(:offering).permit(:title, :description, :price, :location)
  end
endclass OfferingsController < ApplicationController
  def new
  end

  def create
  end
end
