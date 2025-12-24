# frozen_string_literal: true

module Authkeeper
  module Controllers
    module Authentication
      extend ActiveSupport::Concern

      included do
        before_action :set_current_user

        helper_method :current_user
      end

      private

      def set_current_user
        return find_user if Authkeeper.configuration.current_user_cache_minutes.nil?

        access_token = cookies_token.presence || bearer_token.presence || params_token
        return unless access_token

        auth_uuid = Authkeeper::Container['services.fetch_uuid'].call(token: access_token)
        return if auth_uuid[:errors].present?

        user_id =
          Rails.cache.fetch(
            "authkeeper_cached_user_v2/#{auth_uuid[:result]}",
            expires_in: Authkeeper.configuration.current_user_cache_minutes.minutes,
            race_condition_ttl: 10.seconds
          ) do
            find_user
            current_user&.id
          end
        @current_user ||= User.find_by(id: user_id)
      end

      def find_user
        access_token = cookies_token.presence || bearer_token.presence || params_token
        return unless access_token

        auth_call = Authkeeper::Container['services.fetch_session'].call(token: access_token)
        return if auth_call[:errors].present?

        @current_user = auth_call[:result].user
      end

      def current_user = @current_user

      def authenticate
        return if current_user

        if Authkeeper.configuration.fallback_url_session_name
          session[Authkeeper.configuration.fallback_url_session_name] = request.fullpath
        end

        authentication_error
      end

      def authentication_error
        redirect_to root_path, alert: t('controllers.authentication.permission')
      end

      def cookies_token = cookies[access_token_name]
      def params_token = params[access_token_name]

      def bearer_token
        pattern = /^Bearer /
        header = request.headers['Authorization']
        header.gsub(pattern, '') if header&.match(pattern)
      end

      def access_token_name = Authkeeper.configuration.access_token_name

      def sign_in(user)
        user_session = Authkeeper.configuration.user_session_model.constantize.create!(user: user)
        cookies[Authkeeper.configuration.access_token_name] = {
          value: Authkeeper::Container['services.generate_token'].call(user_session: user_session)[:result],
          domain: Authkeeper.configuration.domain,
          expires: 1.week.from_now
        }.compact
      end

      def sign_out
        access_token = cookies_token.presence || bearer_token.presence || params_token

        if access_token
          auth_call = Authkeeper::Container['services.fetch_session'].call(token: access_token)
          auth_call[:result].destroy if auth_call[:result]

          auth_uuid = Authkeeper::Container['services.fetch_uuid'].call(token: access_token)
          Rails.cache.delete("authkeeper_cached_user_v2/#{auth_uuid[:result]}") if auth_uuid[:result]
        end

        cookies.delete(access_token_name)
      end
    end
  end
end
