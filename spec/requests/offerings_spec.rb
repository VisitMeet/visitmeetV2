require 'rails_helper'

RSpec.describe "Offerings", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/offerings/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/offerings/create"
      expect(response).to have_http_status(:success)
    end
  end

end
