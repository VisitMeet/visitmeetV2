require 'rails_helper'

RSpec.describe Activity, type: :model do
  it 'is valid with valid attributes' do
    expect(build(:activity)).to be_valid
  end

  it 'is invalid without a title' do
    activity = build(:activity, title: nil)
    expect(activity).not_to be_valid
    expect(activity.errors[:title]).to include("can't be blank")
  end

  it 'is invalid with a negative price' do
    activity = build(:activity, price: -1)
    expect(activity).not_to be_valid
    expect(activity.errors[:price]).to include('must be greater than or equal to 0')
  end
end

