class CreateRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :rooms do |t|
      t.string :room_name
      t.datetime :last_message_timestamp

      t.timestamps
    end
  end
end
