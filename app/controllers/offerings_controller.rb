class OfferingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_offering, only: [:show, :edit, :update, :destroy]
  before_action :authorize_owner, only: [:edit, :update, :destroy]

  def index
    @offerings = current_user.offerings.order(created_at: :desc)
  end

  def show
    if ActiveRecord::Base.connection.data_source_exists?('reviews')
      @reviews = @offering.reviews.includes(:user)
      @review = Review.new
      @can_review = @offering.bookings.where(user: current_user, status: :completed).exists?
    else
      @reviews = []
      @review = nil
      @can_review = false
    end
  end

  def new
    @offering = current_user.offerings.build
  end

  def create
    @offering = current_user.offerings.build(offering_params)
    if @offering.save
      redirect_to @offering, notice: "Offering created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @offering.update(offering_params)
      redirect_to @offering, notice: "Offering updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @offering.destroy
    redirect_to offerings_path, notice: "Offering deleted successfully!"
  end

  private

  def set_offering
    @offering = Offering.find(params[:id])
  end

  def authorize_owner
    unless @offering.user == current_user
      redirect_to @offering, alert: "You can only edit your own offerings."
    end
  end

  def offering_params
    params.require(:offering).permit(:title, :description, :price, :location)
  end
end
