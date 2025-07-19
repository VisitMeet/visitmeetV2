# spec/features/profile_page_spec.rb

require 'rails_helper'

RSpec.feature "Profile Page", type: :feature, js: true do
  let!(:user) do
    create(
      :user,
      full_name:             'Test User',
      username:              'testuser',
      email:                 'test@example.com',
      password:              'password123',
      password_confirmation: 'password123'
    )
  end

  let!(:other_user) do
    create(
      :user,
      full_name:             'Other User',
      username:              'otheruser',
      email:                 'other@example.com',
      password:              'password123',
      password_confirmation: 'password123'
    )
  end

  let!(:location_tag)   { create(:location_tag,   location: 'kathmandu') }
  let!(:profession_tag) { create(:profession_tag, profession: 'photographer') }

  context "when the owner views their own profile" do
    before do
      login_as(user, scope: :user)
      visit profile_path(user)
    end

    scenario "header shows 'Your Profile' with full name and @username" do
      expect(page).to have_content('Your Profile')
      expect(page).to have_content(user.full_name)
      expect(page).to have_content("@#{user.username}")
    end

    scenario "sees the 'Create New Offering' button" do
      expect(page).to have_link('Create New Offering', href: new_offering_path)
    end

    scenario "can add & remove location tags" do
      find('#add-location-btn').click
      fill_in 'location_tag_input', with: 'kathmandu'
      click_button 'Add'
      expect(page).to have_content('📍 Kathmandu')

      accept_confirm do
        find("button.remove-tag-btn[data-tag-id='#{location_tag.id}']").click
      end
      expect(page).not_to have_content('📍 Kathmandu')
    end

    scenario "can add & remove profession tags" do
      find('#add-profession-btn').click
      fill_in 'profession_tag_input', with: 'photographer'
      click_button 'Add'
      expect(page).to have_content('💼 Photographer')

      accept_confirm do
        find("button.remove-tag-btn[data-tag-id='#{profession_tag.id}']").click
      end
      expect(page).not_to have_content('💼 Photographer')
    end
  end

  context "when another user views this profile" do
    before do
      login_as(other_user, scope: :user)
      visit profile_path(user)
    end

    scenario "does not see add/remove controls or offering link" do
      expect(page).not_to have_selector('#add-location-btn')
      expect(page).not_to have_selector('#add-profession-btn')
      expect(page).not_to have_link('Create New Offering')
    end

    scenario "header shows \"Test User's Profile\" and membership date" do
      expect(page).to have_content("Test User's Profile")
      expect(page).to have_content(user.full_name)
      expect(page).to have_content("@#{user.username}")
      expect(page).to have_content("Member since #{user.created_at.strftime('%B %Y')}")
    end
  end
end