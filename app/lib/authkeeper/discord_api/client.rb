# frozen_string_literal: true

module Authkeeper
  module DiscordApi
    class Client < Authkeeper::HttpService::Client
      include Requests::User

      BASE_URL = 'https://discord.com/api/v10/'

      option :url, default: proc { BASE_URL }

      private

      def headers(access_token)
        {
          'Authorization' => "Bearer #{access_token}"
        }
      end
    end
  end
end
