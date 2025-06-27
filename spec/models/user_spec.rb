require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    describe 'username' do
      it 'is required' do
        user.username = nil
        expect(user).not_to be_valid
        expect(user.errors[:username]).to include("can't be blank")
      end

      it 'must be unique (case insensitive)' do
        create(:user, username: 'TestUser')
        user.username = 'testuser'
        expect(user).not_to be_valid
        expect(user.errors[:username]).to include('has already been taken')
      end

      it 'accepts valid formats' do
        valid_usernames = ['user123', 'test_user', 'user.name', 'User123']
        valid_usernames.each do |username|
          user.username = username
          expect(user).to be_valid, "#{username} should be valid"
        end
      end

      it 'rejects invalid formats' do
        invalid_usernames = ['user-name', 'user name', 'user@name', 'user#123']
        invalid_usernames.each do |username|
          user.username = username
          expect(user).not_to be_valid, "#{username} should be invalid"
          expect(user.errors[:username]).to include('can only contain letters, numbers, underscores, and dots')
        end
      end

      it 'is downcased before saving' do
        user.username = 'TestUser'
        user.save
        expect(user.username).to eq('testuser')
      end
    end

    describe 'full_name' do
      it 'is required' do
        user.full_name = nil
        expect(user).not_to be_valid
        expect(user.errors[:full_name]).to include("can't be blank")
      end

      it 'must be at least 2 characters' do
        user.full_name = 'A'
        expect(user).not_to be_valid
        expect(user.errors[:full_name]).to include('is too short (minimum is 2 characters)')
      end

      it 'must be at most 50 characters' do
        user.full_name = 'A' * 51
        expect(user).not_to be_valid
        expect(user.errors[:full_name]).to include('is too long (maximum is 50 characters)')
      end
    end

    describe 'email' do
      it 'is required' do
        user.email = nil
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("can't be blank")
      end

      it 'must be unique' do
        create(:user, email: 'test@example.com')
        user.email = 'test@example.com'
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include('has already been taken')
      end
    end
  end

  describe 'associations' do
    it 'has many offerings' do
      expect(user).to respond_to(:offerings)
    end

    it 'has many bookings' do
      expect(user).to respond_to(:bookings)
    end

    it 'has many host_bookings through offerings' do
      expect(user).to respond_to(:host_bookings)
    end

    it 'has many location_tags through user_location_tags' do
      expect(user).to respond_to(:location_tags)
    end

    it 'has many profession_tags through user_profession_tags' do
      expect(user).to respond_to(:profession_tags)
    end
  end

  describe 'authentication methods' do
    describe '#login' do
      it 'returns username when present' do
        user.username = 'testuser'
        expect(user.login).to eq('testuser')
      end

      it 'returns email when username is blank' do
        user.username = nil
        user.email = 'test@example.com'
        expect(user.login).to eq('test@example.com')
      end
    end

    describe '.find_for_database_authentication' do
      let!(:existing_user) { create(:user, username: 'testuser', email: 'test@example.com') }

      it 'finds user by username' do
        found_user = User.find_for_database_authentication(login: 'testuser')
        expect(found_user).to eq(existing_user)
      end

      it 'finds user by email' do
        found_user = User.find_for_database_authentication(login: 'test@example.com')
        expect(found_user).to eq(existing_user)
      end

      it 'is case insensitive' do
        found_user = User.find_for_database_authentication(login: 'TestUser')
        expect(found_user).to eq(existing_user)
      end

      it 'returns nil for non-existent login' do
        found_user = User.find_for_database_authentication(login: 'nonexistent')
        expect(found_user).to be_nil
      end
    end
  end

  describe 'display methods' do
    describe '#display_name' do
      it 'returns full_name when present' do
        user.full_name = 'John Doe'
        expect(user.display_name).to eq('John Doe')
      end

      it 'returns username when full_name is blank' do
        user.full_name = ''
        user.username = 'johndoe'
        expect(user.display_name).to eq('johndoe')
      end
    end

    describe '#name_with_username' do
      it 'returns full name with username when both present' do
        user.full_name = 'John Doe'
        user.username = 'johndoe'
        expect(user.name_with_username).to eq('John Doe (@johndoe)')
      end

      it 'returns just username when full_name is blank' do
        user.full_name = ''
        user.username = 'johndoe'
        expect(user.name_with_username).to eq('@johndoe')
      end
    end

    describe '#initials' do
      it 'returns initials from full_name when present' do
        user.full_name = 'John Doe Smith'
        expect(user.initials).to eq('JDS')
      end

      it 'returns first letter of username when full_name is blank' do
        user.full_name = ''
        user.username = 'johndoe'
        expect(user.initials).to eq('J')
      end
    end
  end

  describe 'dependent destroy' do
    let!(:user) { create(:user) }
    let!(:offering) { create(:offering, user: user) }
    let!(:booking) { create(:booking, user: user) }

    it 'destroys associated offerings when user is destroyed' do
      expect { user.destroy }.to change { Offering.count }.by(-1)
    end

    it 'destroys associated bookings when user is destroyed' do
      expect { user.destroy }.to change { Booking.count }.by(-1)
    end
  end
end
