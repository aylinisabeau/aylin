class CategoriesController < ApplicationController
  before_action :find_category, only: [:show, :update]

  def index
    @categories = Category.all
      .page(paginatable_params[:page])
      .per(paginatable_params[:per_page])
    render json: {
      data: ActiveModel::Serializer::CollectionSerializer.new(@categories, serializer: CategorySerializer),
      meta: { pagination: pagination(@categories, paginatable_params) }
    }
  end

  def show
    render json: @category, status: :ok
  end

  def create
    @category = Category.new(categories_params)
    if @category.save
      render json: @category, status: :created
    else
      render json: {  messages: @category.errors }, status: :unprocessable_entity
    end
  end

  def update

    if @category.update(categories_params)
      render json: @category, status: :created
    else
      render json: { messages: @category.errors }, status: :unprocessable_entity
    end
  end

  private

  def find_category
    @category = Category.find(params[:id])
  end

  def categories_params
    params.require(:category).permit(:name, :active_status, :description)
  end
end
