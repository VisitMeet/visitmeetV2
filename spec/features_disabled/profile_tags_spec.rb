# spec/features/profile_tags_spec.rb

require 'rails_helper'

RSpec.feature "Profile Tag Management", type: :feature, js: true do
  let!(:user) do
    create(
      :user,
      full_name:            'Test User',
      username:             'testuser',
      email:                'test@example.com',
      password:             'password123',
      password_confirmation:'password123'
    )
  end

  let!(:location_tag) { create(:location_tag, location: 'kathmandu') }
  let!(:other_user)   do
    create(
      :user,
      full_name:            'Other User',
      username:             'otheruser',
      email:                'other@example.com',
      password:             'password123',
      password_confirmation:'password123'
    )
  end

  before do
    login_as(user, scope: :user)
    visit profile_path(user)
  end

  scenario "Owner can add an existing location tag" do
    find('#add-location-btn').click
    fill_in 'location_tag_input', with: 'kathmandu'
    click_button 'Add'

    expect(page).to have_content('📍 Kathmandu')
  end

  scenario "Owner can cancel adding a location tag" do
    find('#add-location-btn').click
    expect(page).to have_selector('#location_tag_input')

    click_button 'Cancel'

    expect(page).not_to have_selector('#location_tag_input')
    expect(page).to have_selector('#add-location-btn')
  end

  scenario "Owner can remove a location tag" do
    # Pre-associate the tag with the user
    user.location_tags << location_tag
    visit profile_path(user)
    expect(page).to have_content('📍 Kathmandu')

    accept_confirm do
      find("button.remove-tag-btn[data-tag-id='#{location_tag.id}']").click
    end

    expect(page).not_to have_content('📍 Kathmandu')
  end

  scenario "Non-owner cannot see add/remove controls" do
    logout(:user)
    login_as(other_user, scope: :user)

    visit profile_path(user)
    expect(page).not_to have_selector('#add-location-btn')
    expect(page).not_to have_selector('.remove-tag-btn')
  end
end