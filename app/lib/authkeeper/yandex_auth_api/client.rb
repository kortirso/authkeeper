# frozen_string_literal: true

module Authkeeper
  module YandexAuthApi
    class Client < HttpService::Client
      include Requests::FetchAccessToken

      BASE_URL = 'https://oauth.yandex.ru/'

      option :url, default: proc { BASE_URL }
    end
  end
end
