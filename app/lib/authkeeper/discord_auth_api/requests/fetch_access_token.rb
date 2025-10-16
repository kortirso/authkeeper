# frozen_string_literal: true

module Authkeeper
  module DiscordAuthApi
    module Requests
      module FetchAccessToken
        def fetch_access_token(client_id:, client_secret:, code:, redirect_uri:)
          form_post(
            path: 'oauth2/token',
            body: {
              grant_type: 'authorization_code',
              code: code,
              redirect_uri: redirect_uri,
              client_id: client_id,
              client_secret: client_secret
            },
            headers: {
              'Content-Type' => 'application/x-www-form-urlencoded'
            }
          )
        end
      end
    end
  end
end
