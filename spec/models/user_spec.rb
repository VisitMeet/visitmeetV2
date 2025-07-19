require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe "follow and unfollow" do
    it "allows a user to follow another user" do
      expect(user.following?(other_user)).to be_falsey
      user.follow(other_user)
      expect(user.following?(other_user)).to be_truthy
    end

    it "allows a user to unfollow another user" do
      user.follow(other_user)
      expect(user.following?(other_user)).to be_truthy
      user.unfollow(other_user)
      expect(user.following?(other_user)).to be_falsey
    end
  end

  describe "associations" do
    it "has many active_relationships" do
      association = described_class.reflect_on_association(:active_relationships)
      expect(association.macro).to eq :has_many
      expect(association.options[:class_name]).to eq 'Follow'
      expect(association.options[:foreign_key]).to eq 'follower_id'
      expect(association.options[:dependent]).to eq :destroy
    end

    it "has many passive_relationships" do
      association = described_class.reflect_on_association(:passive_relationships)
      expect(association.macro).to eq :has_many
      expect(association.options[:class_name]).to eq 'Follow'
      expect(association.options[:foreign_key]).to eq 'followed_id'
      expect(association.options[:dependent]).to eq :destroy
    end

    it "has many following" do
      association = described_class.reflect_on_association(:following)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :active_relationships
      expect(association.options[:source]).to eq :followed
    end

    it "has many followers" do
      association = described_class.reflect_on_association(:followers)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :passive_relationships
      expect(association.options[:source]).to eq :follower
    end
  end
end