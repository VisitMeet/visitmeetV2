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
end
