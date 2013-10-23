require 'spec_helper'

describe Aveda::Purepro::Client do
  subject{ Aveda::Purepro::Client.new('https://www.example.com:8443') }

  context 'with a working JSON RPC API' do
    context 'when called with a valid user token' do
      let(:result_hash){ {
        'email_address' => 'user@example.com',
        'country' => 'USA',
        'user_id_hash' => 'dXNlckBleGFtcGxlLmNvbQ',
        'first_name' => 'Example',
        'last_name' => 'User'
      } }

      it 'returns user data for that token' do
        with_successful_response do
          expect(subject.user_info_from_token('fe3a94afd3'))
            .to eq(result_hash)
        end
      end
    end

    context 'when called with an invalid user token' do
      it 'raises an Aveda::Purepro::Client::TokenError' do
        with_failure_response do
          expect{ subject.user_info_from_token('fe3a94afd3') }
            .to raise_error(Aveda::Purepro::Client::TokenError)
        end
      end
    end

    context 'when called with an expired user token' do
      it 'raises an Aveda::Purepro::Client::TokenError' do
        with_expired_token do
          expect{ subject.user_info_from_token('fe3a94afd3') }
            .to raise_error(Aveda::Purepro::Client::TokenError, 'expired token')
        end
      end
    end
  end

  context 'with a failing JSON RPC API' do
    it 'raises an Aveda::Purepro::Client::ApiError' do
      with_failing_api do
        expect{ subject.user_info_from_token('fe3a94afd3') }
          .to raise_error(Aveda::Purepro::Client::ApiError, 'test error')
      end
    end
  end

  context 'with an unreachable JSON RPC API' do
    it 'raises an Aveda::Purepro::Client::ApiError' do
      with_network_issues do
        expect{ subject.user_info_from_token('fe3a94afd3') }
          .to raise_error(Aveda::Purepro::Client::ApiError, 'Connection reset by peer')
      end
    end
  end
end

private

def with_response(json_rpc_response)
  faraday_test = Faraday.new do |builder|
    builder.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
      stub.post('') { [200, {}, json_rpc_response] }
    end
  end
  Faraday.stub(:new){ faraday_test }
  yield
end

def with_successful_response
  with_response('[{"error":null,"id":"c88b9414",'\
    '"result":[{"error":null,"id":1,'\
    '"result":{"email_address":"user@example.com",'\
    '"country":"USA","user_id_hash":"dXNlckBleGFtcGxlLmNvbQ",'\
    '"first_name":"Example","last_name":"User"}}]}]'){ yield }
end

def with_failure_response
  with_response('[{"error":null,"id":1,"result":[{"error":"No data","id":1,"result":{}}]}]'){ yield }
end

def with_expired_token
  with_response('[{"error":"TIMEOUT","id":1,"result":null}]'){ yield }
end

def with_failing_api
  with_response('[{"error":"test error","id":1,"result":null}]'){ yield }
end

def with_network_issues
  faraday_test = Faraday.new do |builder|
    builder.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
      stub.post('') { raise Faraday::Error::ConnectionFailed, 'Connection reset by peer' }
    end
  end
  Faraday.stub(:new){ faraday_test }
  yield
end
