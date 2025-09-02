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
end
