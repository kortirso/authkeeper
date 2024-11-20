# frozen_string_literal: true

require 'uri'

module Authkeeper
  module YandexAuthApi
    module Requests
      module FetchAccessToken
        def fetch_access_token(client_id:, client_secret:, code:)
          post(
            path: 'token',
            body: URI.encode_www_form({
              grant_type: 'authorization_code',
              client_id: client_id,
              client_secret: client_secret,
              code: code
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
