# frozen_string_literal: true

require 'uri'
require 'base64'

module Authkeeper
  module YandexAuthApi
    module Requests
      module AccessToken
        def fetch_access_token(client_id:, client_secret:, code:)
          form_post(
            path: 'token',
            body: {
              grant_type: 'authorization_code',
              client_id: client_id,
              client_secret: client_secret,
              code: code
            },
            headers: {
              'Content-Type' => 'application/x-www-form-urlencoded'
            }
          )
        end

        def refresh_access_token(client_id:, client_secret:, refresh_token:)
          form_post(
            path: 'token',
            body: {
              grant_type: 'refresh_token',
              refresh_token: refresh_token
            },
            headers: {
              'Content-Type' => 'application/x-www-form-urlencoded',
              'Authorization' => "Basic #{authorization(client_id, client_secret)}"
            }
          )
        end

        private

        def authorization(client_id, client_secret)
          Base64.encode64("#{client_id}:#{client_secret}").gsub("\n", '')
        end
      end
    end
  end
end
