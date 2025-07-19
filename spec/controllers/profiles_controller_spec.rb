require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do
  let(:user) { create(:user) }
  let(:location_tag) { create(:location_tag) }
  let(:profession_tag) { create(:profession_tag) }

  before do
    sign_in user
  end

  describe "GET #show" do
    before do
      user.location_tags << location_tag
      user.profession_tags << profession_tag
      get :show
    end

    it "returns a successful response" do
      expect(response).to be_successful
    end

    it "assigns the requested user to @user" do
      expect(assigns(:user)).to eq(user)
    end

    it "assigns the user's location tags to @location_tags" do
      expect(assigns(:location_tags)).to include(location_tag)
    end

    it "assigns the user's profession tags to @profession_tags" do
      expect(assigns(:profession_tags)).to include(profession_tag)
    end

    it "assigns all existing location tags to @existing_location_tags" do
      expect(assigns(:existing_location_tags)).to include(location_tag.location)
    end

    it "assigns all existing profession tags to @existing_profession_tags" do
      expect(assigns(:existing_profession_tags)).to include(profession_tag.profession)
    end

    it "sets @is_own_profile to true" do
      expect(assigns(:is_own_profile)).to be_truthy
    end
  end

  describe "POST #add_tag" do
    context "with a new location tag" do
      it "adds a new location tag to the user" do
        expect { post :add_tag, params: { tag_name: "new location", tag_type: "location" } }
          .to change(user.location_tags, :count).by(1)
      end
    end

    context "with an existing location tag" do
      before { user.location_tags << location_tag }
      it "does not add a duplicate location tag" do
        expect { post :add_tag, params: { tag_name: location_tag.location, tag_type: "location" } }
          .not_to change(user.location_tags, :count)
      end
    end

    context "with a new profession tag" do
      it "adds a new profession tag to the user" do
        expect { post :add_tag, params: { tag_name: "new profession", tag_type: "profession" } }
          .to change(user.profession_tags, :count).by(1)
      end
    end

    context "with an existing profession tag" do
      before { user.profession_tags << profession_tag }
      it "does not add a duplicate profession tag" do
        expect { post :add_tag, params: { tag_name: profession_tag.profession, tag_type: "profession" } }
          .not_to change(user.profession_tags, :count)
      end
    end

    it "redirects to the profile page" do
      post :add_tag, params: { tag_name: "some tag", tag_type: "location" }
      expect(response).to redirect_to(profile_path)
    end
  end

  describe "DELETE #remove_tag" do
    before do
      user.location_tags << location_tag
      user.profession_tags << profession_tag
    end

    context "removing a location tag" do
      it "removes the location tag from the user" do
        expect { delete :remove_tag, params: { tag_id: location_tag.id, tag_type: "location" } }
          .to change(user.location_tags, :count).by(-1)
      end
    end

    context "removing a profession tag" do
      it "removes the profession tag from the user" do
        expect { delete :remove_tag, params: { tag_id: profession_tag.id, tag_type: "profession" } }
          .to change(user.profession_tags, :count).by(-1)
      end
    end

    it "returns a successful response" do
      delete :remove_tag, params: { tag_id: location_tag.id, tag_type: "location" }
      expect(response).to have_http_status(:ok)
    end
  end
end