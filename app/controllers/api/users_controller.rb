class Api::UsersController < ApplicationController
    before_action :authorized, only: [:auto_login, :update]
    skip_before_action :verify_authenticity_token

    def create
        @user = User.create(user_params)

        if @user.id
            token = encode_token({user_id: @user.id})
            render json: {user: @user, token: token}
        else
            error_string = ""

            if @user.errors
                error_string = @user.errors.full_messages.join(", ")
            else
                error_string = "Terjadi Kesalahan sistem, silahkan ulangi beberapa saat lagi !"
            end

            render json: {error: error_string}, status: :unprocessable_entity
        end

    end

    def login
        @user = User.find_by(username: params[:username])

        if @user && @user.authenticate(params[:password])
            token = encode_token({user_id: @user.id})
            render json: {user: @user, token: token}
        else
            render json: {error: "Login anda gagal !"}, status: :unprocessable_entity
        end
    end

    def update
        if @user.update(user_params)
            render json: @user
        else
            error_string = ""

            if @user.errors
                error_string = @user.errors.full_messages.join(", ")
            else
                error_string = "Terjadi kesalahan sistem, silahkan ulangi beberapa saat lagi !"
            end
            
            render json: {error: error_string}, status: :unprocessable_entity
        end
    end

    def auto_login
        render json: @user
    end

    private 
        def user_params
            params.permit(:username, :password, :password_confirmation, :name)
        end
end
