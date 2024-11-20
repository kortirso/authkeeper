# frozen_string_literal: true

module Authkeeper
  module Providers
    class Yandex
      include Deps[
        auth_client: 'api.yandex.auth_client',
        api_client: 'api.yandex.client'
      ]

      def call(params: {})
        auth_info = fetch_auth_info(params[:code])
        return { errors: ['Invalid code'] } if auth_info.nil?
        return { errors: ['Invalid code'] } unless auth_info['access_token']

        user_info = fetch_user_info(auth_info['access_token'])
        {
          result: {
            auth_info: auth_info.symbolize_keys,
            user_info: {
              uid: user_info['id'].to_s,
              provider: 'yandex',
              username: user_info['login'],
              email: user_info['default_email'],
              phone_number: user_info.dig('default_phone', 'number')
            }
          }
        }
      end

      private

      def fetch_auth_info(code)
        auth_client.fetch_access_token(
          client_id: omniauth_config[:client_id],
          client_secret: omniauth_config[:client_secret],
          code: code
        )
      end

      def fetch_user_info(access_token)
        api_client.info(access_token: access_token)
      end

      def omniauth_config
        @omniauth_config ||= Authkeeper.configuration.omniauth_configs[:yandex]
      end
    end
  end
end
