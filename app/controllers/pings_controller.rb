class PingsController < ApplicationController
  def ping_user
    target_user = User.find_by(id: pings_params[:target_user_id])
    pinger = User.find_by(id: pings_params[:pinger_id])

    message = " Hi #{target_user&.username || target_user&.name}, you've received a ping from #{pinger&.username}.
    Please click accept to start a chat room or decline to ignore ping"

    Turbo::StreamsChannel.broadcast_update_to [:ping, target_user.id],
                                              target: "ping_#{target_user.id}",
                                              partial: 'shared/notification',
                                              locals: {
                                                target_user:,
                                                pinger:,
                                                message:,
                                                show: true,
                                                signal: 'ping'
                                              }
  end

  def accept
    target_user = User.find_by(id: pings_params[:target_user_id])
    pinger = User.find_by(id: pings_params[:pinger_id])

    message = "#{pinger&.username} wants to connect with you too."

    room = Room.new(
      name: "#{target_user&.username}-#{pinger&.username} #{rand(100)}",
      room_type: 0
    )

    pinger.connections.new(
      room:,
      target_user_id: target_user.id
    )

    room.connection = pinger.connections.last
    room.save

    Turbo::StreamsChannel.broadcast_append_to [:ping, target_user.id],
                                              target: "ping_#{target_user.id}",
                                              partial: 'shared/notification',
                                              locals: {
                                                target_user:,
                                                pinger:,
                                                message:,
                                                show: false,
                                                signal: 'accept-ping'
                                              }
  end

  def decline
    target_user = User.find_by(id: pings_params[:target_user_id])
    pinger = User.find_by(id: pings_params[:pinger_id])

    message = "#{pinger&.username} just declined your ping. You can ping him/her another time"

    Turbo::StreamsChannel.broadcast_append_to [:ping, target_user.id],
                                              target: "ping_#{target_user.id}",
                                              partial: 'shared/notification',
                                              locals: {
                                                target_user:,
                                                pinger:,
                                                message:,
                                                show: false,
                                                signal: 'decline-ping'
                                              }
  end

  private

  def pings_params
    params.permit(
      :target_user_id,
      :pinger_id
    )
  end
end
