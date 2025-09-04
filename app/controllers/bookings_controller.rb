class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking, only: [:show, :edit, :update, :destroy, :accept, :decline, :cancel]
  before_action :set_offering, only: [:new, :create]
  before_action :authorize_booking_access, only: [:show, :edit, :update, :destroy]

  def index
    @bookings = current_user.bookings.includes(:offering).order(created_at: :desc)
  end

  def hosted
    @bookings = current_user.host_bookings.includes(:user, :offering).order(created_at: :desc)
  end

  def show
  end

  def new
    @booking = @offering.bookings.build
    @booking.guests = 1
  end

  def create
    @booking = @offering.bookings.build(booking_params)
    @booking.user = current_user
    @booking.calculate_total_amount
    
    if @booking.save
      redirect_to @booking, notice: 'Booking request sent successfully!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @booking.update(booking_params)
      @booking.calculate_total_amount
      @booking.save
      redirect_to @booking, notice: 'Booking updated successfully!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @booking.destroy
    redirect_to bookings_path, notice: 'Booking cancelled successfully!'
  end
  
  # Custom actions for host management
  def accept
    if @booking.can_be_accepted? && @booking.offering.user == current_user
      @booking.update(status: :accepted)
      redirect_to @booking, notice: 'Booking accepted!'
    else
      redirect_to @booking, alert: 'Cannot accept this booking.'
    end
  end
  
  def decline
    if @booking.pending? && @booking.offering.user == current_user
      @booking.update(status: :declined)
      redirect_to @booking, notice: 'Booking declined.'
    else
      redirect_to @booking, alert: 'Cannot decline this booking.'
    end
  end
  
  def cancel
    if @booking.can_be_cancelled? && (@booking.user == current_user || @booking.offering.user == current_user)
      @booking.update(status: :cancelled)
      redirect_to @booking, notice: 'Booking cancelled.'
    else
      redirect_to @booking, alert: 'Cannot cancel this booking.'
    end
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end
  
  def set_offering
    @offering = Offering.find(params[:offering_id]) if params[:offering_id]
  end

  def booking_params
    params.require(:booking).permit(:requested_date, :guests, :message)
  end
  
  def authorize_booking_access
    unless @booking.user == current_user || @booking.offering.user == current_user
      redirect_to root_path, alert: 'You do not have permission to access this booking.'
    end
  end
end
