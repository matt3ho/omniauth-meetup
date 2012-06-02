require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Meetup < OmniAuth::Strategies::OAuth2
      option :name, "meetup"

      option :client_options, {
        :site => "https://api.meetup.com",
        :authorize_url => 'https://secure.meetup.com/oauth2/authorize',
        :token_url => 'https://secure.meetup.com/oauth2/access'
      }

      def authorize_params
        super.tap do |params|
          params[:response_type] ||= DEFAULT_RESPONSE_TYPE
          params[:client_id] = client.id
        end
      end

      def token_params
        super.tap do |params|
          params[:grant_type] ||= DEFAULT_GRANT
          params[:client_id] = client.id
          params[:client_secret] = client.secret
        end
      end

      uid{ raw_info['id'] }

      info do
        {
          :id => raw_info['id'],
          :name => raw_info['name'],
          :photo_url => raw_info['photo']['photo_link']
        }
      end

      extra do
        { 'raw_info' => raw_info }
      end

      def raw_info
        @raw_info ||= access_token.get("/2/member/self?access_token=#{access_token.token}").parsed
      end

    end
  end
end
