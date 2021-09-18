class Api::RoomsController < ApplicationController
    before_action :authorized
    skip_before_action :verify_authenticity_token

    def index
        @rooms = Room.order 'last_message_timestamp DESC'
        render json: @rooms
    end

    def create
        @room = Room.create room_params

        if @room.id
            render json: {room: @room}
        else
            error_string = ""

            if @room.errors
                error_string = @room.errors.full_messages.join(", ")
            else
                error_string = "Terjadi Kesalahan sistem, silahkan coba beberapa saat lagi !"
            end

            render json: {error: error_string}, status: :unprocessable_entity
        end
    end

    def show
        @room = Room.find params[:id]
    end

    def update
        @room = Room.find params[:id]

        if @room.update room_params
            render json: {room: @room}
        else
            error_string = ""

            if @room.errors
                error_string = @room.errors.full_messages.join(", ")
            else
                error_string = "Terjadi Kesalahan sistem, silahkan coba beberapa saat lagi !"
            end

            render json: {error: error_string}, status: :unprocessable_entity
        end
    end

    def destroy
        @room = Room.find params[:id]

        if @room.destroy
            render json: {message: "Room berhasil di hapus !"}
        else
            render json: {error: "Terjadi kesalahan sistem, silahkan coba beberapa saat lagi !"}
        end
    end

    private
        def room_params
            params.permit(:room_name)
        end
end
