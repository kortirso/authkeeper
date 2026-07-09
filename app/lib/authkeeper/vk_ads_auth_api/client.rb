# frozen_string_literal: true

module Authkeeper
  module VkAdsAuthApi
    class Client < Authkeeper::HttpService::Client
      include Requests::AccessToken
      include Requests::Info

      BASE_URL = 'https://ads.vk.ru/api/v2/oauth2/'

      option :url, default: proc { BASE_URL }
    end
  end
end
