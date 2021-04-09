require 'rails_helper'

RSpec.describe Category, type: :model do
  subject {
    FactoryBot.build(:category)
  }

  describe 'associations' do
    it { should have_many(:products) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should define_enum_for(:active_status).with_values([:inactive, :active])}
  end
end
