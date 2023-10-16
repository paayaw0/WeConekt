module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user, :current_room, :current_room_connection

    def connect
      self.current_user = find_verified_user
      self.current_room = find_current_room
      self.current_room_connection = find_current_room_connection
    end

    private

    def find_verified_user
      if verified_user = User.find_by(id: cookies.encrypted['_weconekt_session']['user_id'])
        verified_user
      else
        reject_unauthorized_connection
      end
    end

    def find_current_room
      return unless verified_room = Room.find_by(id: cookies.encrypted['_weconekt_session']['room_id'])

      verified_room
    end

    def find_current_room_connection
      return unless verified_room_connection = current_user.connections
                                                           .find_by(id: cookies.encrypted['_weconekt_session']['connection_id'])

      verified_room_connection
    end
  end
end
