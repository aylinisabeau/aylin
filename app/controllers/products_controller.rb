class ProductsController < ApplicationController
    before_action :authenticate_user
    before_action :find_product, only: [:show, :update]

    def index
        @products = Product.all
        .page(paginatable_params[:page])
        .per(paginatable_params[:per_page])
        render json: {
            data: ActiveModel::Serializer::CollectionSerializer.new(@products, serializer: ProductSerializer),
            meta: { pagination: pagination(@products, paginatable_params) }
        }
    end

    def show
        render json: @product, status: :ok
    end

    def create
        @product = Product.new(products_params)
        if @product.save
            render json: @product, status: :created
        else
            render json: {  messages: @product.errors }, status: :unprocessable_entity
        end
    end

    def update
        if @product.update(products_params)
            render json: @product, status: :ok
        else
            render json: { messages: @product.errors }, status: :unprocessable_entity
        end
    end

    private

    def find_product
        @product = Product.find(params[:id])
    end

    def products_params
        params.require(:product).permit(:id, :name, :active_status, :price, :category_id)
    end

end


