module OmniAuth
  module Strategies
    class AvedaPurepro
      class TokenError < StandardError; end

      include OmniAuth::Strategy

      option :name, 'aveda_purepro'
      option :auth_url
      option :rpc_endpoint_url

      def request_phase
        redirect options.auth_url
      end

      def callback_phase
        raise TokenError, 'missing USER_TOKEN' if request.params['USER_TOKEN'].to_s.empty?

        client = Aveda::Purepro::Client.new(options.rpc_endpoint_url)
        @raw_info = client.user_info_from_token(request.params['USER_TOKEN'])
        super
      rescue TokenError, Aveda::Purepro::Client::TokenError => e
        fail!(:token_error, e)
      rescue Errno::ETIMEDOUT, Errno::ECONNREFUSED, Aveda::Purepro::Client::ApiError => e
        fail!(:connection_error, e)
      end

      uid do
        @raw_info['email_address']
      end

      info do
        {
          :email => @raw_info['email_address'],
          :first_name => @raw_info['first_name'],
          :last_name => @raw_info['last_name']
        }
      end

      extra do
        { :raw_info => @raw_info }
      end
    end
  end
end
