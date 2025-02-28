require 'rails_helper'

RSpec.describe UserTag, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:tag) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:tag_id) }
  end

  describe 'adding tags to user' do
    let(:user) { create(:user) }
    let(:tag) { create(:tag) }

    it 'successfully adds a tag to a user' do
      user_tag = UserTag.create(user: user, tag: tag)
      expect(user_tag).to be_valid
      expect(user_tag.user).to eq(user)
      expect(user_tag.tag).to eq(tag)
    end

    it 'does not add a tag without a user' do
      user_tag = UserTag.create(tag: tag)
      expect(user_tag).not_to be_valid
    end

    it 'does not add a tag without a tag' do
      user_tag = UserTag.create(user: user)
      expect(user_tag).not_to be_valid
    end
  end
end
