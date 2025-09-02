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
end
