class ProductsController < ApplicationController

  def index
    @products = Product.all
      .page(paginatable_params[:page])
      .per(paginatable_params[:per_page])
    render json: {
      data: @products,
      meta: { pagination: pagination(@products, paginatable_params) }
    }
  end

  private

  def products_params
    params.require(:product).permit(:name, :active_status, :price, :category_id)
  end

end


