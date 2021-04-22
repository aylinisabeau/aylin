require 'rails_helper'
RSpec.describe "Products", type: :request do
  describe "GET /products" do
    before(:all) do
      FactoryBot.create_list :product, 20
      get products_path
      @response_data = JSON.parse(response.body)
    end
    it "should get all the products" do
      scoped_data = Product.all.limit(10)
      expect(@response_data["data"].map{ |d| d["id"] }).to match_array(scoped_data.map(&:id))
    end
    it "should have :ok status" do
      expect(response.status).to eq (200)
    end
    include_examples "paginated list"
  end

  describe "GET /products/:id" do
    before(:all) do
      @product = FactoryBot.create :product
      get product_path(@product)
      @response_data = JSON.parse(response.body)
    end
    it "should get a product with all its attributes" do
      expect(@response_data["id"]).to eq @product.id
      expect(@response_data["name"]).to eq @product.name
      expect(@response_data["active_status"]).to eq true
      expect(@response_data["price"]).to eq @product.price.to_s
      expect(@response_data["category_id"]).to eq @product.category_id
      expect(@response_data).to have_key("category")
      expect(Time.zone.parse(@response_data["created_at"]).to_i).to eq(@product.created_at.to_i)
      expect(Time.zone.parse(@response_data["updated_at"]).to_i).to eq(@product.updated_at.to_i)
    end
    it "should response with status :ok" do
      expect(response.status).to eq (200)
    end
  end

  describe "POST /products"do
    context "valid product" do
      before(:all)do
        @category = FactoryBot.create(:category)
        @product = FactoryBot.attributes_for(:product)
        @product[:category_id] = @category.id
        post products_path, params: { product: @product }
        @response_data = JSON.parse(response.body)
      end
      it "should respond with :created" do
        expect(response.status).to eq 201
      end
      it "should have created a new product" do
        expect(@response_data).to have_key("id")
      end
    end

    context "invalid product" do
      before(:all) do
        @product = FactoryBot.attributes_for(:product)
        @product[:name] = ""
        @product[:category_id] = ""
        post products_path, params: { product: @product }
        @response_data = JSON.parse(response.body)
      end
      it "should respond with :unprocessable_entity" do
        expect(response.status).to eq 422
      end
      it "should have an error message" do
        expect(@response_data).to have_key("messages")
        expect(@response_data["messages"]["name"]).to include "can't be blank"
      end
      it "should not have a category" do
        expect(@response_data["messages"]["category"]).to include "must exist"
      end
    end
  end

  describe "PUT /products/:id" do
    context "valid product" do
      before(:all) do
        @category = FactoryBot.create(:category)
        @product = FactoryBot.create(:product)
        @product[:category_id] = @category.id

        @products_params = {
          name: "Producto1",
          active_status: true,
          price: "20.0",
          category_id: @category.id
        }

        put product_path(@product), params: { product: @products_params}
        @response_data = JSON.parse(response.body)
     end

      it "should response with :ok" do
        expect(response.status).to eq 200
      end

      it "should have updated the product" do
        expect(@response_data["name"]).to eq @products_params[:name]
        expect(@response_data["active_status"]).to eq @products_params[:active_status]
        expect(@response_data["price"]).to eq @products_params[:price]
        expect(@response_data["category_id"]).to eq @products_params[:category_id]
      end
    end

    context "invalid product"do
      before(:all)do
        @category = FactoryBot.create(:category)
        @product = FactoryBot.create(:product)

        @products_params = {
          name: "",
          active_status: false,
          price: "9.99",
          category_id: ""
        }

        put product_path(@product), params: { product: @products_params }
        @response_data = JSON.parse(response.body)
      end

      it "should response with :unprocessable_entity" do
        expect(response.status).to eq 422
      end
      it "should not have updated product"do
        expect(Product.find(@product.id).name).to eq @product.name
        expect(Product.find(@product.id).active_status).to eq @product.active_status
        expect(Product.find(@product.id).price).to eq @product.price
        expect(Product.find(@product.id).category_id).to eq @product.category_id
      end

      it "should have an error message"do
        expect(@response_data["messages"]["name"]).to include"can't be blank"
        expect(@response_data["messages"]["category"]).to include "must exist"
      end
    end
  end
end
