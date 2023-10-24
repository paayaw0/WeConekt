require 'rails_helper'

RSpec.describe 'Rooms', type: :request do
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

  before do
    room.connections << [pinger_connection, target_connection]
    room.save
    post '/sessions', params: pinger.attributes.slice('email').merge!(password: pinger.password)
  end

  describe 'GET #index' do
    before { get '/rooms' }

    it 'render index template' do
      expect(response).to render_template(:index)
    end

    it 'should have a 200 http status response code' do
      expect(response).to have_http_status(200)
    end

    it 'should render list of rooms for signed in user' do
      rooms = assigns[:rooms]
      expect(rooms).to eq([room])
    end
  end

  describe 'GET #show' do
    before { get "/rooms/#{room.id}" }

    it 'render show template' do
      expect(response).to render_template(:show)
    end

    it 'should have a 200 http status response code' do
      expect(response).to have_http_status(200)
    end

    it 'return users in chat room' do
      users = assigns[:users]
      expect(users).to contain_exactly(pinger, target_user)
    end
  end

  describe 'POST #join' do
    let!(:params) do
      {
        target_user_id: target_user.id,
        pinger_id: pinger.id,
        room_id: room.id
      }
    end
    before { post '/join_room', params: }

    it 'redirect to room' do
      expect(response).to redirect_to room_path(room)
    end

    it 'should have a 302 http status response code' do
      expect(response).to have_http_status(302)
    end
  end
end
