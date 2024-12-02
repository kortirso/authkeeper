# frozen_string_literal: true

require 'uri'

module Authkeeper
  module VkAuthApi
    module Requests
      module AccessToken
        def fetch_access_token(client_id:, redirect_url:, device_id:, code:, state:, code_verifier:)
          post(
            path: 'oauth2/auth',
            body: URI.encode_www_form({
              grant_type: 'authorization_code',
              client_id: client_id,
              device_id: device_id,
              code: code,
              state: state,
              redirect_uri: redirect_url,
              code_verifier: code_verifier
            }),
            headers: {
              'Content-Type' => 'application/x-www-form-urlencoded'
            }
          )
        end

        def refresh_access_token(client_id:, refresh_token:, device_id:, state:)
          post(
            path: 'oauth2/auth',
            body: URI.encode_www_form({
              grant_type: 'refresh_token',
              client_id: client_id,
              device_id: device_id,
              refresh_token: refresh_token,
              state: state
            }),
            headers: {
              'Content-Type' => 'application/x-www-form-urlencoded'
            }
          )
        end
      end
    end
  end
end
