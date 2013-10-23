require 'faraday'
require 'multi_json'
require 'securerandom'

module Aveda
  class Purepro
    class Client
      class ApiError   < IOError; end
      class TokenError < ArgumentError; end

      def initialize(url)
        @url = url
        @connection = Faraday.new(:url => url)
      end

      def user_info_from_token(user_token)
        payload = payload_for_pgdata(user_token)
        response = @connection.post('', { 'JSONRPC' => payload })
        parse_response(response)
      rescue Faraday::Error::ClientError => e
        raise ApiError, e
      end

      private

      def self.make_id
        SecureRandom.uuid
      end

      def payload_for_pgdata(user_token)
        MultiJson.encode({
          :id => self.class.make_id,
          :method => 'user.getPGData',
          :params => [user_token]
        })
      end

      def parse_response(response)
        data = MultiJson.decode(response.body).first
        raise TokenError, 'expired token' if data['error'] == 'TIMEOUT'
        raise ApiError, data['error'] unless data['error'].nil?

        result = data['result'].first
        raise TokenError, result['error'] unless result['error'].nil?

        result['result']
      end
    end
  end
end
