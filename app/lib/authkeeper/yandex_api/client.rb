# frozen_string_literal: true

module YandexApi
  class Client < HttpService::Client
    include Requests::Info

    BASE_URL = 'https://login.yandex.ru/'

    option :url, default: proc { BASE_URL }
  end
end
