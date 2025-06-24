# spec/features/authentication_spec.rb

require 'rails_helper'

RSpec.feature "Authentication", type: :feature do
  let!(:user) do
    create(
      :user,
      username:              'testuser',
      email:                 'test@example.com',
      password:              'password123',
      password_confirmation: 'password123'
    )
  end

  scenario "User can sign up with username, full name, and email" do
    visit new_user_registration_path

    fill_in 'Full name',             with: 'New User'
    fill_in 'Username',              with: 'newuser'
    fill_in 'Email',                 with: 'newuser@example.com'
    fill_in 'Password',              with: 'password123'
    fill_in 'Password confirmation', with: 'password123'
    click_button 'Sign up'

    expect(page).to have_content('Welcome! You have signed up successfully.')
    expect(page).to have_link('My Profile')
  end

  scenario "User can log in with username", js: true do
    visit new_user_session_path

    fill_in 'Username or Email', with: 'testuser'
    fill_in 'Password',          with: 'password123'
    click_button 'Sign In'

    expect(page).to have_content('Signed in successfully.')
    expect(page).to have_link('My Profile')
    expect(page).to have_link('My Offerings')
  end

  scenario "User can log in with email" do
    visit new_user_session_path

    fill_in 'Username or Email', with: 'test@example.com'
    fill_in 'Password',          with: 'password123'
    click_button 'Sign In'

    expect(page).to have_content('Signed in successfully.')
    expect(page).to have_link('My Profile')
  end

  scenario "User cannot log in with invalid credentials" do
    visit new_user_session_path

    fill_in 'Username or Email', with: 'testuser'
    fill_in 'Password',          with: 'wrongpassword'
    click_button 'Sign In'

    expect(page).to have_content('Invalid Login or password.')
    expect(page).not_to have_link('My Profile')
  end

  scenario "User can log out", js: true do
    login_as(user, scope: :user)
    visit root_path

    click_link 'Sign out'

    expect(page).to have_content('Signed out successfully.')
    expect(page).to have_link('Log in')
    expect(page).to have_link('Sign up')
    expect(page).not_to have_link('My Profile')
  end

  scenario "Authenticated user can access profile" do
    login_as(user, scope: :user)
    visit profile_path(user)

    expect(page).to have_content('Your Profile')
    expect(page).to have_content("@#{user.username}")
  end

  scenario "Unauthenticated user cannot access profile" do
    visit profile_path(user)

    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end

  scenario "Unauthenticated user cannot access offerings" do
    visit offerings_path

    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end

  scenario "User can navigate between auth pages" do
    visit new_user_session_path

    click_link 'Create account'
    expect(current_path).to eq(new_user_registration_path)

    click_link 'Log in'
    expect(current_path).to eq(new_user_session_path)
  end
end