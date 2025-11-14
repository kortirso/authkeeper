# frozen_string_literal: true

module Authkeeper
  module DiscordAuthApi
    class Client < Authkeeper::HttpService::Client
      include Requests::FetchAccessToken

      BASE_URL = 'https://discord.com/api/v10/'

      option :url, default: proc { BASE_URL }
    end
  end
end
