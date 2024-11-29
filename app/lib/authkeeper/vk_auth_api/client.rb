# frozen_string_literal: true

module Authkeeper
  module VkAuthApi
    class Client < HttpService::Client
      include Requests::FetchAccessToken
      include Requests::Info

      BASE_URL = 'https://id.vk.com/'

      option :url, default: proc { BASE_URL }
    end
  end
end
