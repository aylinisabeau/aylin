class ApplicationController < ActionController::Base
  def index
    render json: Category.all, status: :ok
  end
end
