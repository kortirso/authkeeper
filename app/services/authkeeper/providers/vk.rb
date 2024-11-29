# frozen_string_literal: true

module Authkeeper
  module Providers
    class Vk
      include AuthkeeperDeps[
        auth_client: 'api.vk.auth_client'
      ]

      def call(params: {})
        auth_info = fetch_auth_info(params)
        # {
        #   "refresh_token" => "vk2.a.",
        #   "access_token" => "vk2.a.",
        #   "id_token" => "",
        #   "token_type" => "Bearer",
        #   "expires_in" => 3600,
        #   "user_id" => 176780000,
        #   "state" => "ce4a09792e2cc8065a96074906709765",
        #   "scope" => "vkid.personal_info email"
        # }

        user_info = fetch_user_info(auth_info['access_token'])
        # {
        #   "user" => {
        #     "user_id" => "176780000",
        #     "first_name" => "",
        #     "last_name" => "",
        #     "avatar" => "",
        #     "email" => "",
        #     "sex" => 2,
        #     "verified" => false,
        #     "birthday" => "01.01.2000"
        #   }
        # }

        {
          result: {
            auth_info: auth_info.symbolize_keys,
            user_info: {
              uid: user_info.dig('user', 'user_id'),
              provider: 'vk',
              email: user_info.dig('user', 'email'),
              phone_number: "+#{user_info.dig('user', 'phone')}"
            }
          }
        }
      end

      private

      def fetch_auth_info(params)
        auth_client.fetch_access_token(
          client_id: omniauth_config[:client_id],
          redirect_url: omniauth_config[:redirect_url],
          device_id: params[:device_id],
          code: params[:code],
          state: params[:state],
          code_verifier: params[:code_verifier]
        )
      end

      def fetch_user_info(access_token)
        auth_client.info(access_token: access_token, client_id: omniauth_config[:client_id])
      end

      def omniauth_config
        @omniauth_config ||= Authkeeper.configuration.omniauth_configs[:vk]
      end
    end
  end
end
