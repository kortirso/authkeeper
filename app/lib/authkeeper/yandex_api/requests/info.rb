# frozen_string_literal: true

module Authkeeper
  module YandexApi
    module Requests
      module Info
        def info(access_token:)
          get(
            path: 'info',
            headers: { 'Authorization' => "OAuth #{access_token}" }
          )
        end
      end
    end
  end
end
