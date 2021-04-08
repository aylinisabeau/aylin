class ApplicationController < ActionController::Base
  def index
    render json: Category.all
  end
end
