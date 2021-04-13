class CategoriesController < ApplicationController
  def index
    @categories = Category.all
      .page(paginatable_params[:page])
      .per(paginatable_params[:per_page])
    render json: {
      data: @categories,
      meta: { pagination: pagination(@categories, paginatable_params) }
    }
  end

  private

  def categories_params
    params.require(:category).permit(:name, :active_status, :description)
  end
end
