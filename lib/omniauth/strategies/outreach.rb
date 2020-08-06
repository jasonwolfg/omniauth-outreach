require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Outreach < OmniAuth::Strategies::OAuth2
      option :name, 'outreach'
      option :client_options, {
        :site => 'https://api.outreach.io',
        :authorize_url => "https://api.outreach.io/oauth/authorize",
        :token_url => "https://api.outreach.io/oauth/token?grant_type=authorization_code"
      }

      uid do
        raw_info['meta']['user']['id']
      end

      info do
        {
          email: raw_info['meta']['user']['email']
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def raw_info
        puts "raw info #{access_token.get('/api/v2', parse: :json).parsed}"
        @raw_info ||= access_token.get('/api/v2', parse: :json).parsed
      end

      # Work-around for https://github.com/intridea/omniauth-oauth2/issues/93.
      def callback_url
        options[:redirect_uri] || (full_host + script_name + callback_path)
      end
    end
  end
end
