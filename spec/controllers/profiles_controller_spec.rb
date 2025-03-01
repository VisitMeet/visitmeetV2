require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do
  let(:user) { create(:user) }
  let(:tag) { create(:tag) }

  describe 'GET #show' do
    it 'returns a successful response' do
      get :show, params: { id: user.id }
      expect(response).to be_successful
    end

    it 'assigns the requested user to @user' do
      get :show, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end

    it 'assigns the user tags to @tags' do
      user.tags << tag
      get :show, params: { id: user.id }
      expect(assigns(:tags)).to include(tag)
    end

    it 'assigns all existing tags to @existing_tags' do
      tag
      get :show, params: { id: user.id }
      expect(assigns(:existing_tags)).to include(tag.name)
    end
  end

  describe 'POST #add_tag' do
    it 'adds a tag to the user' do
      expect {
        post :add_tag, params: { id: user.id, tag_name: tag.name }
      }.to change(user.tags, :count).by(1)
    end

    it 'redirects to the profile page' do
      post :add_tag, params: { id: user.id, tag_name: tag.name }
      expect(response).to redirect_to(profile_path(user))
    end
  end

  describe 'DELETE #remove_tag' do
    before { user.tags << tag }

    it 'removes the tag from the user' do
      expect {
        delete :remove_tag, params: { id: user.id, tag_id: tag.id }
      }.to change(user.tags, :count).by(-1)
    end

    it 'returns a successful response' do
      delete :remove_tag, params: { id: user.id, tag_id: tag.id }
      expect(response).to have_http_status(:ok)
    end
  end
end
