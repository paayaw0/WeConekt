require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET #new' do
    before { get '/signup' }

    it 'renders new template for sign up' do
      expect(response).to render_template(:new)
    end

    it 'responds to with ok status' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST #create' do
    context 'successfully creates user on sign up' do
      let(:valid_params) { { user: { email: 'paayaw.dev@gmail.com', password: 'heLL0_World#?' } } }

      it 'creates user on sign up' do
        expect do
          post '/users', params: valid_params
        end.to change(User, :count).by(1)
      end

      it 'displays success flash message' do
        post '/users', params: valid_params

        user = assigns[:user]
        expect(flash[:success]).to eq("Hello #{user.name || user.username} and welcome to WeConekt")
      end

      it 'redirects to root path' do
        post '/users', params: valid_params

        user = assigns[:user]
        expect(response).to redirect_to user_path(user)
      end

      it 'has a redirect status code of 302' do
        post '/users', params: valid_params

        expect(response).to have_http_status(302)
      end
    end

    context 'unsuccessful sign up' do
      let(:invalid_params) { { user: { email: 'paayaw.dev@gmail.com', password: 'weakpassword' } } }

      it 'fails to create a user' do
        expect do
          post '/users', params: invalid_params
        end.to change(User, :count).by(0)
      end

      it 'displays error flash message' do
        post '/users', params: invalid_params

        expect(flash[:error]).to eq('Failed to create your profile. Please check and resolve the errors')
      end

      it 'renders new template' do
        post '/users', params: invalid_params

        expect(response).to render_template(:new)
      end

      it 'has status code of 422' do
        post '/users', params: invalid_params

        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'GET #show' do
    let!(:existing_user) { create(:user) }
    let!(:user_password) { existing_user.password }
    let(:valid_params) { { user: { email: 'paayaw.dev@gmail.com', password: user_password } } }

    before do
      post '/sessions', params: valid_params[:user]
      get "/users/#{existing_user.id}"
    end

    it 'renders show template' do
      expect(response).to render_template(:show)
    end

    it 'has 200 status code' do
      expect(response).to have_http_status(200)
    end

    it 'returns valid user' do
      expect(assigns[:user]).to eq(existing_user)
    end
  end

  describe 'GET #edit' do
    let!(:existing_user) { create(:user) }
    let!(:user_password) { existing_user.password }
    let(:valid_params) { { user: { email: 'paayaw.dev@gmail.com', password: user_password } } }

    before do
      post '/sessions', params: valid_params[:user]
      get "/users/#{existing_user.id}/edit"
    end

    it 'renders edit template' do
      expect(response).to render_template(:edit)
    end

    it 'has 200 status code' do
      expect(response).to have_http_status(200)
    end

    it 'return valid user' do
      expect(assigns[:user]).to eq(existing_user)
    end
  end

  describe 'PATCH #update' do
    let!(:existing_user) { create(:user) }
    let!(:user_password) { existing_user.password }
    let(:valid_params) { { user: { email: 'paayaw.dev@gmail.com', password: user_password } } }

    context 'when current user exists' do
      before { post '/sessions', params: valid_params[:user] }

      context 'successfully updated' do
        before { patch "/users/#{existing_user.id}", params: valid_params }

        it 'redirects to root path' do
          expect(response).to redirect_to user_path(existing_user)
        end

        it 'displays successful flash message' do
          expect(flash[:success]).to eq('You successful updated your profile')
        end

        it 'has 302 as status code' do
          expect(response).to have_http_status(302)
        end
      end

      context 'unsuccessful update' do
        let(:invalid_params) { { user: { email: 'paayaw.dev@gmail.com', password: 'weakpassword' } } }

        before { patch "/users/#{existing_user.id}", params: invalid_params }

        it 'displays error flash message' do
          expect(flash[:error]).to eq('Profile update failed')
        end

        it 'renders edit template' do
          expect(response).to render_template(:edit)
        end

        it 'has status code of 422' do
          expect(response).to have_http_status(422)
        end
      end
    end

    context 'when current_user is absent' do
      context 'unsuccessful update' do
        let(:invalid_params) { { user: { email: 'paayaw.dev@gmail.com', password: 'weakpassword' } } }

        before { patch "/users/#{existing_user.id}", params: invalid_params }

        it 'displays error flash message' do
          expect(flash[:error]).to eq('You must be signed in first')
        end

        it 'redirects to sign up page' do
          expect(response).to redirect_to login_path
        end

        it 'has status code of 302' do
          expect(response).to have_http_status(302)
        end
      end
    end
  end
end
