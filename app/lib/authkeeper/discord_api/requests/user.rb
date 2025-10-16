# frozen_string_literal: true

module Authkeeper
  module DiscordApi
    module Requests
      module User
        def user(access_token:)
          get(
            path: 'oauth2/@me',
            headers: headers(access_token)
          )
        end
      end
    end
  end
end
