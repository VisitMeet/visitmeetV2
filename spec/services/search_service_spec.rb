require 'rails_helper'

RSpec.describe SearchService do
  it 'returns users, offerings and reviews matching keywords' do
    user = create(:user)
    tag = create(:tag, name: 'photography')
    UserTag.create!(user: user, tag: tag)

    offering = create(:offering, title: 'Photography tour', description: 'Great shots', location: 'nepal', user: user)
    review_user = create(:user)
    review = create(:review, offering: offering, user: review_user, comment: 'Amazing photography experience')

    results = SearchService.new(['photography']).call
    expect(results[:users]).to include(user)
    expect(results[:offerings]).to include(offering)
    expect(results[:reviews]).to include(review)
  end

  it 'respects result limits when provided' do
    tag = create(:tag, name: 'photography')
    user1 = create(:user)
    user2 = create(:user)
    UserTag.create!(user: user1, tag: tag)
    UserTag.create!(user: user2, tag: tag)

    offering1 = create(:offering, title: 'Photography tour', description: 'Great shots', location: 'nepal', user: user1)
    offering2 = create(:offering, title: 'Photography workshop', description: 'Learn skills', location: 'india', user: user2)

    review_user = create(:user)
    create(:review, offering: offering1, user: review_user, comment: 'Amazing photography experience')
    create(:review, offering: offering2, user: review_user, comment: 'Another photography review')

    results = SearchService.new(['photography'], limit: 1).call

    expect(results[:users].count).to eq(1)
    expect(results[:offerings].count).to eq(1)
    expect(results[:reviews].count).to eq(1)
  end

  it 'handles multiple keywords across resources' do
    user = create(:user)
    tag1 = create(:tag, name: 'photography')
    tag2 = create(:tag, name: 'tour')
    UserTag.create!(user: user, tag: tag1)
    UserTag.create!(user: user, tag: tag2)

    offering = create(:offering, title: 'Photography tour', description: 'Tour with photography', location: 'nepal', user: user)
    review_user = create(:user)
    review = create(:review, offering: offering, user: review_user, comment: 'Great photography tour')

    results = SearchService.new(%w[photography tour]).call

    expect(results[:users]).to include(user)
    expect(results[:offerings]).to include(offering)
    expect(results[:reviews]).to include(review)
  end

  it 'returns empty results when no matches found' do
    create(:user)
    results = SearchService.new(['nonexistent']).call

    expect(results[:users]).to be_empty
    expect(results[:offerings]).to be_empty
    expect(results[:reviews]).to be_empty
  end

  it 'supports fuzzy matching for typos' do
    user = create(:user)
    offering = create(:offering, title: 'Hiking adventure', description: 'Enjoy hiking', location: 'nepal', user: user)
    review_user = create(:user)
    review = create(:review, offering: offering, user: review_user, comment: 'Great hiking experience')

    results = SearchService.new(['hikng']).call

    expect(results[:offerings]).to include(offering)
    expect(results[:reviews]).to include(review)
  end
end
