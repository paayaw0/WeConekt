module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user, :current_room

    def connect
      self.current_room = find_current_room
      self.current_user = find_verified_user
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
  end
end
