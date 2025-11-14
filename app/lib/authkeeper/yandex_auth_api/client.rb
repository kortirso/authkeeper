# frozen_string_literal: true

module Authkeeper
  module YandexAuthApi
    class Client < Authkeeper::HttpService::Client
      include Requests::AccessToken

      BASE_URL = 'https://oauth.yandex.ru/'

      option :url, default: proc { BASE_URL }
    end
  end
end
