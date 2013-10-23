require 'spec_helper'

describe OmniAuth::Strategies::AvedaPurepro do
  include OmniAuth::Test::StrategyTestCase

  let(:purepro_options) do
    {
      :auth_url => 'https://www.example.com/redirects/company.tmpl',
      :rpc_endpoint_url => 'https://www.example.com:8443'
    }
  end
  let(:strategy){ [OmniAuth::Strategies::AvedaPurepro, purepro_options] }

  context 'request phase' do
    before(:each){ get '/auth/aveda_purepro' }

    it 'redirects to the configured aveda purepro login page' do
      expect(last_response).to be_redirect
      expect(last_response['Location']).to eq(purepro_options[:auth_url])
    end
  end

  context 'callback phase' do
    context 'called without a user token' do
      before(:each){ get '/auth/aveda_purepro/callback' }

      it 'redirects to the failure url' do
        expect(last_response).to be_redirect
        expect(last_response['Location']).to eq('/auth/failure?message=token_error&strategy=aveda_purepro')
      end
    end

    context 'called with a blank user token' do
      before(:each){ get '/auth/aveda_purepro/callback?USER_TOKEN=' }

      it 'redirects to the failure url' do
        expect(last_response).to be_redirect
        expect(last_response['Location']).to eq('/auth/failure?message=token_error&strategy=aveda_purepro')
      end
    end

    it 'calls the configured aveda json rpc endpoint url with the rpc request' do
      client_double = double(Aveda::Purepro::Client)
      stub_const('Aveda::Purepro::Client', client_double)

      expect(client_double).to receive(:new).with(purepro_options[:rpc_endpoint_url]).and_return(client_double)
      expect(client_double).to receive(:user_info_from_token).with('fe3a94afd3').and_return({})

      get '/auth/aveda_purepro/callback?USER_TOKEN=fe3a94afd3'
    end

    context 'with a valid user token' do
      let(:auth_hash){ last_request.env['omniauth.auth'] }
      let(:user_info) do
        {
          'email_address' => 'user@example.com',
          'country' => 'USA',
          'user_id_hash' => 'dXNlckBleGFtcGxlLmNvbQ',
          'first_name' => 'Example',
          'last_name' => 'User'
        }
      end

      before(:each) do
        Aveda::Purepro::Client.any_instance.stub(:user_info_from_token).and_return(user_info)
        get '/auth/aveda_purepro/callback?USER_TOKEN=fe3a94afd3'
      end

      it 'creates a valid omniauth hash' do
        expect(auth_hash).to be_valid
      end

      it 'sets provider in the omniauth hash' do
        expect(auth_hash.provider).to eq('aveda_purepro')
      end

      it 'sets uid in the omniauth hash' do
        expect(auth_hash.uid).to eq('user@example.com')
      end

      it 'sets email in the omniauth hash' do
        expect(auth_hash.info.email).to eq('user@example.com')
      end

      it 'sets name in the omniauth hash' do
        expect(auth_hash.info.name).to eq('Example User')
      end

      it 'sets raw_info in the omniauth hash' do
        expect(auth_hash.extra.raw_info.to_hash).to eq(user_info)
      end
    end

    context 'with an invalid user token' do
      before(:each) do
        Aveda::Purepro::Client.any_instance.stub(:user_info_from_token)
          .and_raise(Aveda::Purepro::Client::TokenError, 'test token exception')
        get '/auth/aveda_purepro/callback?USER_TOKEN=fe3a94afd3'
      end

      it 'redirects to the failure url' do
        expect(last_response).to be_redirect
        expect(last_response['Location']).to eq('/auth/failure?message=token_error&strategy=aveda_purepro')
      end
    end

    context 'with a failing api' do
      before(:each) do
        Aveda::Purepro::Client.any_instance.stub(:user_info_from_token)
          .and_raise(Aveda::Purepro::Client::ApiError, 'test api exception')
        get '/auth/aveda_purepro/callback?USER_TOKEN=fe3a94afd3'
      end

      it 'redirects to the failure url' do
        expect(last_response).to be_redirect
        expect(last_response['Location']).to eq('/auth/failure?message=connection_error&strategy=aveda_purepro')
      end
    end
  end
end
