class RoomChannel < ApplicationCable::Channel
  def subscribed
    if params[:room_id].present?
      stream_from("ChatRoom-#{params[:room_id]}")
    end
  end

  def speak(data)
    sender = get_sender(data)
    room_id = data['room_id']
    message = data['message']

    raise 'No room_id!' if room_id.blank?
    convo = get_convo(room_id)
    raise 'No conversation found!' if convo.blank?
    raise 'No message!' if message.blank?

    Message.create!(
      room: convo,
      user: sender,
      content: message
    )
  end

  def get_convo(room_id)
    Room.find room_id
  end

  def get_sender
    User.find id
  end
end
