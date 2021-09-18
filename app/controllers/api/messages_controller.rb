class Api::MessagesController < ApplicationController
    before_action :authorized
    skip_before_action :verify_authenticity_token

    def index
        @room = Room.find params[:room_id]

        if @room
            @messages = @room.messages.order 'created_at DESC'
            render json: {messages: @messages}
        else
            render json: {error: 'Room tidak ditemukan !'}, status: 404
        end
    end

    def create
        @room = Room.find params[:room_id]
        @message = @room.messages.new message_params
        @message.user_id = @user.id

        unless @message.save
            error_string = ""

            if @message.errors
                error_string = @message.errors.full_messages.join(", ")
            else
                error_string = "Terjadi Kesalahan sistem, silahkan ulangi beberapa saat lagi !"
            end

            render json: {error: error_string}, status: :unprocessable_entity
        else
            @room.update(last_message_timestamp: @message.created_at)
        end
    end

    private
        def message_params
            params.require(:message).permit(:content)
        end
end
