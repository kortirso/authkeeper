# frozen_string_literal: true

module Authkeeper
  module GoogleAuthApi
    class Client < Authkeeper::HttpService::Client
      include Requests::FetchAccessToken

      BASE_URL = 'https://www.googleapis.com/'

      option :url, default: proc { BASE_URL }
    end
  end
end
