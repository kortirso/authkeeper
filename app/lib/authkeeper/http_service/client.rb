# frozen_string_literal: true

require 'dry/initializer'

module Authkeeper
  module HttpService
    class Client
      extend Dry::Initializer[undefined: false]

      option :url
      option :connection, default: proc { build_connection }

      def get(path:, params: nil, headers: nil)
        if Rails.env.test? && connection.adapter != 'Faraday::Adapter::Test'
          raise StandardError, 'please stub request in test env'
        end

        response = connection.get(path, params, headers)
        {
          success: response.success?,
          body: response.body
        }
      end

      def no_params_post(path:, body: nil, headers: nil)
        if Rails.env.test? && connection.adapter != 'Faraday::Adapter::Test'
          raise StandardError, 'please stub request in test env'
        end

        response = connection.post(path, body, headers)
        response.body if response.success?
      end

      def post(path:, body: {}, params: {}, headers: {}) # rubocop: disable Metrics/AbcSize
        if Rails.env.test? && connection.adapter != 'Faraday::Adapter::Test'
          raise StandardError, 'please stub request in test env'
        end

        response = connection.post(path) do |request|
          params.each do |param, value|
            request.params[param] = value
          end
          headers.each do |header, value|
            request.headers[header] = value
          end
          request.body = body.to_json
        end
        response.body if response.success?
      end

      def form_post(path:, body: {}, params: {}, headers: {})
        if Rails.env.test? && connection.adapter != 'Faraday::Adapter::Test'
          raise StandardError, 'please stub request in test env'
        end

        response = connection.post(path) do |request|
          params.each do |param, value|
            request.params[param] = value
          end
          headers.each do |header, value|
            request.headers[header] = value
          end
          request.body = URI.encode_www_form(body)
        end
        response.body if response.success?
      end
      # rubocop: enable Metrics/AbcSize

      private

      def build_connection
        Faraday.new(@url) do |conn|
          conn.request :url_encoded
          conn.response :json, content_type: /\bjson$/
          conn.adapter Faraday.default_adapter
        end
      end
    end
  end
end
