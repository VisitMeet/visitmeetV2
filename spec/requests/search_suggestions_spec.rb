require 'rails_helper'

RSpec.describe "SearchSuggestions", type: :request do
  describe "GET /search_suggestions" do
    it "returns tags and locations matching the query" do
      create(:tag, name: 'photography')
      create(:location_tag, location: 'phuket')

      get search_suggestions_path, params: { q: 'ph' }

      expect(response).to have_http_status(:success)
      data = JSON.parse(response.body)
      expect(data['tags']).to include('photography')
      expect(data['locations']).to include('phuket')
    end

    it "returns bad request when query is missing" do
      get search_suggestions_path

      expect(response).to have_http_status(:bad_request)
      data = JSON.parse(response.body)
      expect(data['error']).to be_present
    end
  end
end
