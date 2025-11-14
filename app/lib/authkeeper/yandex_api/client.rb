# frozen_string_literal: true

module Authkeeper
  module YandexApi
    class Client < Authkeeper::HttpService::Client
      include Requests::Info

      BASE_URL = 'https://login.yandex.ru/'

      option :url, default: proc { BASE_URL }
    end
  end
end
