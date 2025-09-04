require 'rails_helper'

RSpec.describe "Bookings", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET /bookings" do
    it "returns http success" do
      get bookings_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /bookings/hosted" do
    it "returns http success" do
      get hosted_bookings_path
      expect(response).to have_http_status(:success)
    end
  end
end
