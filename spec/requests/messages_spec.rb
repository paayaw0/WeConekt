require 'rails_helper'

RSpec.describe 'Messages', type: :request do
  let!(:pinger) { create(:user, email: 'pinger@gmail.com') }
  let!(:target_user) { create(:user, email: 'target@gmail.com') }
  let!(:room) do
    build(:room, name: "#{target_user&.username}-#{pinger&.username} #{rand(100)}",
                  room_type: 0)
  end
  let!(:pinger_connection) do
    build(:connection, user_id: pinger.id,
                       room_id: room.id)
  end
  let!(:target_connection) do
    build(:connection, user_id: target_user.id,
                       room_id: room.id)
  end

  let!(:text) { 'hell there' }

  before do
    room.connections << [pinger_connection, target_connection]
    room.save
    post '/sessions', params: pinger.attributes.slice('email').merge!(password: pinger.password)
  end

  describe 'POST #create' do
    let!(:params) do
      {
        text:,
        room_id: room.id,
        user_id: pinger.id
      }
    end

    it 'creates message' do
      expect do
        post "/users/#{pinger.id}/messages", params:
      end.to change(Message, :count).by(1)
    end
  end

  describe 'PATCH #update' do
    let!(:message) do
      create(:message, room_id: room.id,
                       user_id: pinger.id,
                       text: 'Old Text')
    end

    let!(:params) do
      {
        message:
       {
         text: 'Updated Text!'
       }
      }
    end

    it 'can edit message' do
      patch("/messages/#{message.id}", params:)
      message = assigns[:message]

      expect(message.text).to eq(params[:message][:text])
    end
  end

  describe 'DELETE #destroy' do
    let!(:message) do
      create(:message, room_id: room.id,
                       user_id: pinger.id,
                       text: 'Old Text')
    end

    it 'can delete message' do
      expect{ 
        delete "/messages/#{message.id}"
      }.to change(Message, :count).by(-1)
    end
  end
end