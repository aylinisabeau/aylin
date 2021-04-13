require 'rails_helper'

RSpec.describe "Categories", type: :request do
  describe "GET /categories" do
    before(:all) do
      FactoryBot.create_list :category, 20
      get categories_path
      @response_data = JSON.parse(response.body)
    end

    it "should get all the categories" do
      scoped_data = Category.all.limit(10)
      expect(@response_data["data"].map{ |d| d["id"] }).to match_array(scoped_data.map(&:id))
    end

    it "should have :ok status" do
      expect(response.status).to eq(200)
    end

    include_examples "paginated list"
  end
end
