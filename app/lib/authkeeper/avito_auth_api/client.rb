# frozen_string_literal: true

module Authkeeper
  module AvitoAuthApi
    class Client < Authkeeper::HttpService::Client
      include Requests::AccessToken

      BASE_URL = 'https://api.avito.ru/'

      option :url, default: proc { BASE_URL }
    end
  end
end
