require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'GET #new' do
    it 'renders log in form' do
      get '/login'

      expect(response).to render_template(:new)
    end

    it 'expect ok response as status code' do
      get '/login'

      expect(response).to have_http_status(200)
    end
  end

  describe 'POST #create' do
    let!(:existing_user) { create(:user) }
    let!(:user_password) { existing_user.password }

    context 'successful login with valid params' do
      let(:valid_params) { { email: 'paayaw.dev@gmail.com', password: user_password } }

      it 'expect redirect 302 response as status code' do
        post '/sessions', params: valid_params

        expect(response).to have_http_status(302)
      end

      it 'expect flash message to welcome user' do
        post '/sessions', params: valid_params

        expect(flash[:success]).to eq("Welcome Back, #{existing_user.name || existing_user.username}")
      end

      it 'expect response to redirect to root_path' do
        post '/sessions', params: valid_params

        expect(response).to redirect_to user_path(existing_user)
      end
    end

    context 'unsuccessful login with invalid params' do
      let(:invalid_params) { { email: 'paayaw.dev@gmail.com', password: 'some_passWord0' } }

      it 'flash message to tell users to sign up' do
        post '/sessions', params: invalid_params

        expect(flash[:error]).to eq('Invalid email/password')
      end

      it 'expect redirect to sign up page' do
        post '/sessions', params: invalid_params

        expect(response).to render_template(:new)
      end

      it 'expect status code to be 401, unauthorized' do
        post '/sessions', params: invalid_params

        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:existing_user) { create(:user) }
    let!(:user_password) { existing_user.password }
    let(:valid_params) { { email: 'paayaw.dev@gmail.com', password: user_password } }

    context 'when there is a current user' do 
      before do
        post '/sessions', params: valid_params
      end

      it 'log out' do
        delete '/logout'

        expect(flash[:notice]).to eq("You've successfully logged out")
      end

      it 'redirects to log in path' do
        delete '/logout'

        expect(response).to redirect_to login_path
      end
    end

    context 'when there is no current user' do
      it 'log out' do
        delete '/logout'

        expect(flash[:error]).to eq('You must be signed in first')
      end

      it 'redirects to log in path' do
        delete '/logout'

        expect(response).to redirect_to login_path
      end
    end
  end
end
