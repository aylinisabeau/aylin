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
  describe "GET /categories/:id" do
    before(:all) do
      @category = FactoryBot.create :category
      get category_path(@category)
      @response_data = JSON.parse(response.body)
    end
    it "should get a category with all its attributes" do
      expect(@response_data["id"]).to eq @category.id
      expect(@response_data["name"]).to eq @category.name
      expect(@response_data["active_status"]).to eq true
      expect(@response_data["description"]).to eq @category.description
      expect(Time.zone.parse(@response_data["created_at"]).to_i).to eq(@category.created_at.to_i)
      expect(Time.zone.parse(@response_data["updated_at"]).to_i).to eq(@category.updated_at.to_i)
    end
    it "should respond with :ok" do
      expect(response.status).to eq 200
    end
  end
  describe "POST /categories" do
    context "valid category" do
      before(:all) do
        @category = FactoryBot.attributes_for(:category)
        post categories_path, params: { category: @category }
        @response_data = JSON.parse(response.body)
      end
      it "should respond with :created" do
        expect(response.status).to eq 201
      end
      it "should have created a new category" do
        expect(@response_data).to have_key("id")
      end
    end
    context "invalid category" do
      before(:all) do
        @category = FactoryBot.attributes_for(:category)
        @category[:name] = ""
        post categories_path, params: { category: @category }
        @response_data = JSON.parse(response.body)
      end
      it "should response with :unprocessable_entity" do
        expect(response.status).to eq 422
      end
      it "should have an error message" do
        expect(@response_data).to have_key("messages")
        expect(@response_data["messages"]["name"]).to include "can't be blank"
      end
    end
  end

  describe  "PUT / categories /: id"do
   context "valid category" do
      before(:all)do
        @category = FactoryBot.create(:category)

        @categories_params = {
          name: "Hola Aylin",
          active_status: false
        }

        put category_path(@category), params: { category: @categories_params}
        @response_data = JSON.parse(response.body)
     end

     it "should response with :ok" do
      expect(response.status).to eq 201
     end

     it "should have updated the category" do
      expect(@response_data["name"]).to eq @categories_params[:name]
      expect(@response_data["active_status"]).to eq @categories_params[:active_status]
     end
    end

    context "invalid category"do
      before(:all)do
        @category = FactoryBot.create(:category)

        @categories_params = {
          name: "",
          active_status: false
        }

        put category_path(@category), params: { category: @categories_params }
        @response_data = JSON.parse(response.body)
      end

      it "should response with :unprocessable_entity" do
        expect(response.status).to eq 422
      end
      it "should not have updated category"do
        expect(Category.find(@category.id).name).to eq @category.name
        expect(Category.find(@category.id).active_status).to eq @category.active_status
      end

      it "should have an error message"do
        expect(@response_data["messages"]["name"]).to include"can't be blank"
      end
    end

  end

end
