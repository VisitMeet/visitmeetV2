require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  let(:offering) { create(:offering) }
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'POST #create' do
    context 'with completed booking' do
      before { create(:booking, :completed, user: user, offering: offering) }

      it 'creates a review' do
        expect {
          post :create, params: { offering_id: offering.id, review: { rating: 4, comment: 'Nice' } }
        }.to change(Review, :count).by(1)
        expect(response).to redirect_to(offering)
      end
    end

    context 'without completed booking' do
      it 'does not create a review' do
        expect {
          post :create, params: { offering_id: offering.id, review: { rating: 4, comment: 'Nice' } }
        }.not_to change(Review, :count)
        expect(response).to redirect_to(offering)
        expect(flash[:alert]).to eq('You can only review offerings you have completed.')
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:review) { create(:review, offering: offering, user: user) }

    it 'destroys the review' do
      expect {
        delete :destroy, params: { offering_id: offering.id, id: review.id }
      }.to change(Review, :count).by(-1)
      expect(response).to redirect_to(offering)
    end
  end
end
