# frozen_string_literal: true

require 'uri'

module Authkeeper
  module VkAdsAuthApi
    module Requests
      module AccessToken
        def fetch_access_token(client_id:, code:)
          form_post(
            path: 'token.json',
            body: {
              grant_type: 'authorization_code',
              client_id: client_id,
              code: code
            },
            headers: {
              'Content-Type' => 'application/x-www-form-urlencoded'
            }
          )
        end

        def refresh_access_token(client_id:, refresh_token:, client_secret:)
          form_post(
            path: 'token.json',
            body: {
              grant_type: 'refresh_token',
              client_id: client_id,
              refresh_token: refresh_token,
              client_secret: client_secret
            },
            headers: {
              'Content-Type' => 'application/x-www-form-urlencoded'
            }
          )
        end

        def remove_access_token(client_id:, client_secret:, username: nil, user_id: nil)
          form_post(
            path: 'token/delete.json',
            body: {
              client_id: client_id,
              client_secret: client_secret,
              username: username,
              user_id: user_id
            }.compact,
            headers: {
              'Content-Type' => 'application/x-www-form-urlencoded'
            }
          )
        end
      end
    end
  end
end
