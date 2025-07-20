require 'rails_helper'

RSpec.describe Conversation, type: :model do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  describe 'associations' do
    it { should belong_to(:sender).class_name('User') }
    it { should belong_to(:recipient).class_name('User') }
    it { should have_many(:messages).dependent(:destroy) }
  end

  describe 'validations' do
    it 'validates uniqueness of sender_id scoped to recipient_id' do
      create(:conversation, sender: user1, recipient: user2)
      should validate_uniqueness_of(:sender_id).scoped_to(:recipient_id)
    end
  end

  describe '.between' do
    let!(:conversation1) { create(:conversation, sender: user1, recipient: user2) }
    let!(:conversation2) { create(:conversation, sender: user2, recipient: user1) }
    let!(:conversation3) { create(:conversation, sender: user1, recipient: create(:user)) }

    it 'returns conversations between two users regardless of sender/recipient order' do
      expect(Conversation.between(user1.id, user2.id)).to include(conversation1, conversation2)
      expect(Conversation.between(user1.id, user2.id).count).to eq(2)
    end

    it 'does not return conversations with other users' do
      expect(Conversation.between(user1.id, user2.id)).not_to include(conversation3)
    end
  end
end
