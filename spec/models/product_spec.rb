require 'rails_helper'

RSpec.describe Product, type: :model do
  subject {
    FactoryBot.build(:product)
  }

  describe 'associations' do
    it { should belong_to(:category) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_numericality_of(:price).is_greater_than(0) }
    it { should define_enum_for(:active_status).with_values([:inactive, :active])}
  end
end
