require 'rails_helper'

RSpec.describe Booking, type: :model do
  let(:user) { create(:user) }
  let(:offering) { create(:offering) }
  let(:booking) { build(:booking, user: user, offering: offering) }

  describe 'associations' do
    it 'belongs to user' do
      expect(booking.user).to eq(user)
    end

    it 'belongs to offering' do
      expect(booking.offering).to eq(offering)
    end
  end

  describe 'validations' do
    it 'validates presence of required fields' do
      booking = Booking.new
      booking.valid?
      expect(booking.errors[:requested_date]).to include("can't be blank")
      expect(booking.errors[:total_amount]).to include("can't be blank")
      expect(booking.errors[:user]).to include("must exist")
      expect(booking.errors[:offering]).to include("must exist")
    end

    it 'validates guests is within range' do
      booking.guests = 0
      expect(booking).not_to be_valid
      expect(booking.errors[:guests]).to include("must be greater than 0")

      booking.guests = 25
      expect(booking).not_to be_valid
      expect(booking.errors[:guests]).to include("must be less than or equal to 20")
    end

    it 'validates requested_date cannot be in the past' do
      booking.requested_date = 1.day.ago
      expect(booking).not_to be_valid
      expect(booking.errors[:requested_date]).to include("can't be in the past")
    end

    it 'validates user cannot book their own offering' do
      booking.user = offering.user
      expect(booking).not_to be_valid
      expect(booking.errors[:base]).to include("You cannot book your own offering")
    end
  end

  describe 'status enum' do
    it 'defines correct statuses' do
      expect(Booking.statuses).to eq({
        'pending' => 0,
        'accepted' => 1,
        'declined' => 2,
        'cancelled' => 3,
        'completed' => 4
      })
    end
  end

  describe 'scopes' do
    let!(:host) { create(:user) }
    let!(:host_offering) { create(:offering, user: host) }
    let!(:traveler) { create(:user) }
    let!(:booking1) { create(:booking, offering: host_offering, user: traveler) }
    let!(:booking2) { create(:booking, offering: host_offering, user: traveler) }

    describe '.for_host' do
      it 'returns bookings for offerings owned by the user' do
        expect(Booking.for_host(host)).to include(booking1, booking2)
        expect(Booking.for_host(traveler)).to be_empty
      end
    end

    describe '.for_traveler' do
      it 'returns bookings made by the user' do
        expect(Booking.for_traveler(traveler)).to include(booking1, booking2)
        expect(Booking.for_traveler(host)).to be_empty
      end
    end

    describe '.upcoming' do
      it 'returns bookings with future dates' do
        future_booking = create(:booking, requested_date: 1.week.from_now)
        
        # Create past booking by updating after creation to bypass validation
        past_booking = create(:booking, requested_date: 1.week.from_now)
        past_booking.update_column(:requested_date, 1.week.ago)
        
        expect(Booking.upcoming).to include(future_booking)
        expect(Booking.upcoming).not_to include(past_booking)
      end
    end
  end

  describe 'instance methods' do
    describe '#host' do
      it 'returns the offering owner' do
        expect(booking.host).to eq(offering.user)
      end
    end

    describe '#traveler' do
      it 'returns the booking user' do
        expect(booking.traveler).to eq(user)
      end
    end

    describe '#can_be_accepted?' do
      it 'returns true for pending future bookings' do
        booking.status = :pending
        booking.requested_date = 1.week.from_now
        expect(booking.can_be_accepted?).to be true
      end

      it 'returns false for past bookings' do
        booking.status = :pending
        booking.requested_date = 1.week.ago
        expect(booking.can_be_accepted?).to be false
      end

      it 'returns false for non-pending bookings' do
        booking.status = :accepted
        booking.requested_date = 1.week.from_now
        expect(booking.can_be_accepted?).to be false
      end
    end

    describe '#calculate_total_amount' do
      it 'calculates total based on offering price and guests' do
        offering.update(price: 50)
        booking.guests = 3
        booking.calculate_total_amount
        expect(booking.total_amount).to eq(150)
      end
    end
  end
end
