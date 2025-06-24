require 'rails_helper'

RSpec.describe "Authentication", type: :request do
  let!(:user) { create(:user, username: 'testuser', email: 'test@example.com', password: 'password123') }

  describe "GET /users/sign_in" do
    it "returns http success" do
      get new_user_session_path
      expect(response).to have_http_status(:success)
    end

    it "displays login form" do
      get new_user_session_path
      expect(response.body).to include('Log in')
      expect(response.body).to include('Login')
      expect(response.body).to include('Password')
    end
  end

  describe "POST /users/sign_in" do
    context "with valid credentials (username)" do
      it "logs in user and redirects" do
        post user_session_path, params: {
          user: {
            login: 'testuser',
            password: 'password123'
          }
        }
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include('Signed in successfully')
      end
    end

    context "with valid credentials (email)" do
      it "logs in user and redirects" do
        post user_session_path, params: {
          user: {
            login: 'test@example.com',
            password: 'password123'
          }
        }
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid credentials" do
      it "does not log in user" do
        post user_session_path, params: {
          user: {
            login: 'testuser',
            password: 'wrongpassword'
          }
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('Invalid Login or password')
      end
    end
  end

  describe "DELETE /users/sign_out" do
    before { sign_in user }

    it "logs out user and redirects" do
      delete destroy_user_session_path
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include('Signed out successfully')
    end
  end

  describe "Protected routes" do
    context "when not authenticated" do
      it "redirects to login for profile" do
        get profile_path(user)
        expect(response).to redirect_to(new_user_session_path)
      end

      it "redirects to login for offerings" do
        get offerings_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      before { sign_in user }

      it "allows access to profile" do
        get profile_path(user)
        expect(response).to have_http_status(:success)
      end

      it "allows access to offerings" do
        get offerings_path
        expect(response).to have_http_status(:success)
      end
    end
  end
end