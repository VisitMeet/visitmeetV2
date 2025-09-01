require 'rails_helper'

RSpec.describe MessagesController, type: :request do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let!(:conversation) { create(:conversation, sender: user1, recipient: user2) }

  before do
    sign_in user1
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get conversation_messages_path(conversation)
      expect(response).to be_successful
    end

    it 'assigns messages to @messages' do
      message = create(:message, conversation: conversation, user: user1)
      get conversation_messages_path(conversation)
      expect(assigns(:messages)).to include(message)
    end

    it 'assigns a new message to @message' do
      get conversation_messages_path(conversation)
      expect(assigns(:message)).to be_a_new(Message)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new message' do
        expect do
          post conversation_messages_path(conversation), params: { message: { body: "Hello" } }
        end.to change(Message, :count).by(1)
      end

      it 'redirects to the conversation messages path' do
        post conversation_messages_path(conversation), params: { message: { body: "Hello" } }
        expect(response).to redirect_to(conversation_messages_path(conversation))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new message' do
        expect do
          post conversation_messages_path(conversation), params: { message: { body: "" } }
        end.not_to change(Message, :count)
      end

      it 'renders the index template with unprocessable_entity status' do
        post conversation_messages_path(conversation), params: { message: { body: "" } }
        expect(response).to render_template(:index)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when the message belongs to the current user' do
      it 'deletes the message' do
        message = create(:message, conversation: conversation, user: user1)
        expect do
          delete conversation_message_path(conversation, message)
        end.to change(Message, :count).by(-1)
        expect(response).to redirect_to(conversation_messages_path(conversation))
      end
    end

    context "when the message belongs to another user" do
      it 'does not delete the message and returns forbidden' do
        message = create(:message, conversation: conversation, user: user2)
        expect do
          delete conversation_message_path(conversation, message)
        end.not_to change(Message, :count)
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PATCH #update' do
    context 'when the message belongs to the current user' do
      it 'updates the message' do
        message = create(:message, conversation: conversation, user: user1, body: 'Old body')
        patch conversation_message_path(conversation, message), params: { message: { body: 'Updated body' } }
        expect(response).to redirect_to(conversation_messages_path(conversation))
        expect(message.reload.body).to eq('Updated body')
      end
    end

    context 'when the message belongs to another user' do
      it 'does not update the message and returns forbidden' do
        message = create(:message, conversation: conversation, user: user2, body: 'Original body')
        patch conversation_message_path(conversation, message), params: { message: { body: 'Hacked body' } }
        expect(response).to have_http_status(:forbidden)
        expect(message.reload.body).to eq('Original body')
      end
    end
  end
end
