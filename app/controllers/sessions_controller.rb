class SessionsController < ApplicationController
    before_action :authenticate_user, only: [:persist]
    def login
        @user = User.login(login_params)
        if @user.errors.empty?
            render json: @user
        else
            render json: { messages: @user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def persist
        @current_user.valid_until = Time.zone.now + 30.minutes
        @current_user.generate_token
        if @current_user.errors.empty?
            render json: @current_user
        else
            render json: { messages: @current_user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    private

    def login_params
        params.require(:auth).permit(:email, :password)
    end
end
