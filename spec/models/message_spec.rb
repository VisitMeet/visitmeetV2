require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'associations' do
    it { should belong_to(:conversation) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:body) }
  end

  describe 'callbacks' do
    let(:conversation) { create(:conversation) }
    let(:user) { create(:user) }

    it 'broadcasts to the conversation after creation' do
      expect do
        Message.create!(conversation: conversation, user: user, body: "Test message")
      end.to have_broadcasted_to(conversation).with(a_hash_including(body: "Test message"))
    end
  end
end
