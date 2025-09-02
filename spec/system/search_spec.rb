require 'rails_helper'

RSpec.describe 'Search', type: :system do
  it 'adds and removes search chips with live updates', js: true do
    user = create(:user)
    tag = create(:tag, name: 'photography')
    UserTag.create!(user: user, tag: tag)
    create(:offering, title: 'Photography tour', user: user, description: 'Great shots', location: 'nepal')

    visit search_results_path

    find('[data-search-tags-target="input"]').fill_in(with: 'photography')
    find('[data-search-tags-target="input"]').send_keys(:enter)

    expect(page).to have_css('[data-search-tags-target="tags"]', text: 'photography')
    expect(page).to have_content('Photography tour')

    within('[data-search-tags-target="tags"]') do
      click_button '×'
    end

    expect(page).to have_content('No matches found')
  end

  it 'finds users by location', js: true do
    user = create(:user, full_name: 'Guide In Pokhara')
    location_tag = create(:location_tag, location: 'pokhara')
    UserLocationTag.create!(user: user, location_tag: location_tag)

    visit search_results_path

    find('[data-search-tags-target="input"]').fill_in(with: 'pokhara')
    find('[data-search-tags-target="input"]').send_keys(:enter)

    expect(page).to have_content('Guide In Pokhara')
  end
end
