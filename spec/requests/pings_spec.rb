require 'rails_helper'

RSpec.describe 'Pings', type: :request do
  let!(:pinger) { create(:user, email: 'pinger@gmail.com') }
  let!(:target_user) { create(:user, email: 'target@gmail.com') }

  before do
    post '/sessions', params: pinger.attributes.slice('email').merge!(password: pinger.password)
  end

  describe 'POST #ping_user' do
    let!(:params) do
      {
        target_user_id: target_user.id,
        pinger_id: pinger.id
      }
    end

    it 'renders no template' do
      post '/ping', as: :turbo_stream, params: params
      expect(response).to render_template(layout: false)
    end

    it 'have 204 status code' do
      post '/ping', as: :turbo_stream, params: params
      expect(response).to have_http_status(204)
    end

    it 'renders shared/notifiation template' do
      post '/ping',as: :turbo_stream, params: params
      expect(response).to render_template('shared/_notification')
    end
  end

  describe 'POST #accept_ping' do
    let!(:params) do
      {
        target_user_id: target_user.id,
        pinger_id: pinger.id
      }
    end

    it 'renders no template' do
      post '/accept_ping', as: :turbo_stream, params: params
      expect(response).to render_template(layout: false)
    end

    it 'have 204 status code' do
      post '/accept_ping', as: :turbo_stream, params: params
      expect(response).to have_http_status(204)
    end

    it 'renders shared/notifiation template' do
      post '/accept_ping',as: :turbo_stream, params: params
      expect(response).to render_template('shared/_notification')
    end

    it 'creates room' do
      expect { 
        post '/accept_ping',as: :turbo_stream, params: params
      }.to change(Room, :count).by(1)
    end

    it 'creates connection' do
      expect { 
        post '/accept_ping',as: :turbo_stream, params: params
      }.to change(Connection, :count).by(1)
    end
  end

  describe 'POST #decline_ping' do
    let!(:params) do
      {
        target_user_id: target_user.id,
        pinger_id: pinger.id
      }
    end

    it 'renders no template' do
      post '/decline_ping', as: :turbo_stream, params: params
      expect(response).to render_template(layout: false)
    end

    it 'have 204 status code' do
      post '/decline_ping', as: :turbo_stream, params: params
      expect(response).to have_http_status(204)
    end

    it 'renders shared/notifiation template' do
      post '/decline_ping',as: :turbo_stream, params: params
      expect(response).to render_template('shared/_notification')
    end

    it 'does not creates room' do
      expect { 
        post '/decline_ping',as: :turbo_stream, params: params
      }.to change(Room, :count).by(0)
    end

    it 'does not creates connection' do
      expect { 
        post '/decline_ping',as: :turbo_stream, params: params
      }.to change(Connection, :count).by(0)
    end
  end
end
