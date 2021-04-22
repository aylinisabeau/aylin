class SessionsController < ApplicationController
    def login
        @user = User.login(login_params)
        if @user.errors.empty?
            render json: @user
        else
            render json: @user.errors.full_messages, status: :unprocessable_entity
        end
    end

    private

    def login_params
        params.require(:auth).permit(:email, :password)
    end
end
