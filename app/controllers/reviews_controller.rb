class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_offering
  before_action :set_review, only: [:destroy]

  def create
    unless can_review?
      redirect_to @offering, alert: 'You can only review offerings you have completed.'
      return
    end

    @review = @offering.reviews.build(review_params.merge(user: current_user))
    if @review.save
      redirect_to @offering, notice: 'Review created successfully.'
    else
      @reviews = @offering.reviews.includes(:user)
      render 'offerings/show', status: :unprocessable_entity
    end
  end

  def destroy
    if @review.user == current_user
      @review.destroy
    end
    redirect_to @offering
  end

  private

  def set_offering
    @offering = Offering.find(params[:offering_id])
  end

  def set_review
    @review = @offering.reviews.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end

  def can_review?
    @offering.bookings.where(user: current_user, status: :completed).exists?
  end
end
