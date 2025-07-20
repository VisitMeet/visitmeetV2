require 'rails_helper'

RSpec.describe ConversationsController, type: :request do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  before do
    sign_in user1
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get conversations_path
      expect(response).to be_successful
    end

    it 'assigns current user\'s conversations to @conversations' do
      conversation = create(:conversation, sender: user1, recipient: user2)
      get conversations_path
      expect(assigns(:conversations)).to include(conversation)
    end
  end

  describe 'POST #create' do
    context 'when a conversation already exists' do
      let!(:existing_conversation) { create(:conversation, sender: user1, recipient: user2) }

      it 'redirects to the existing conversation\'s messages path' do
        post conversations_path, params: { sender_id: user1.id, recipient_id: user2.id }
        expect(response).to redirect_to(conversation_messages_path(existing_conversation))
      end

      it 'does not create a new conversation' do
        expect do
          post conversations_path, params: { sender_id: user1.id, recipient_id: user2.id }
        end.not_to change(Conversation, :count)
      end
    end

    context 'when a conversation does not exist' do
      it 'creates a new conversation' do
        expect do
          post conversations_path, params: { sender_id: user1.id, recipient_id: user2.id }
        end.to change(Conversation, :count).by(1)
      end

      it 'redirects to the new conversation\'s messages path' do
        post conversations_path, params: { sender_id: user1.id, recipient_id: user2.id }
        expect(response).to redirect_to(conversation_messages_path(Conversation.last))
      end
    end
  end
end
