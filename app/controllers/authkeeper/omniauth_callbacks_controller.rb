# frozen_string_literal: true

module Authkeeper
  class OmniauthCallbacksController < ::ApplicationController
    include AuthkeeperDeps[
      fetch_session: 'services.fetch_session',
      generate_token: 'services.generate_token'
    ]

    GITHUB = 'github'
    GITLAB = 'gitlab'
    TELEGRAM = 'telegram'
    GOOGLE = 'google'
    YANDEX = 'yandex'

    skip_before_action :verify_authenticity_token
    skip_before_action :authenticate, only: %i[create]
    before_action :validate_provider, only: %i[create]
    before_action :validate_auth, only: %i[create]

    def create; end

    def destroy
      fetch_session
        .call(token: cookies[Authkeeper.configuration.access_token_name])[:result]
        &.destroy
      cookies.delete(Authkeeper.configuration.access_token_name)
      redirect_to root_path
    end

    private

    def validate_provider
      authentication_error if Authkeeper.configuration.omniauth_providers.exclude?(params[:provider])
    end

    def validate_auth
      return validate_telegram_auth if params[:provider] == TELEGRAM

      validate_general_auth
    end

    def validate_general_auth
      authentication_error if params[:code].blank? || auth.nil?
    end

    def validate_telegram_auth
      authentication_error if params[:id].blank? || auth.nil?
    end

    def auth
      @auth ||= provider_service(params[:provider]).call(params: params)[:result]
    end

    def provider_service(provider)
      Authkeeper::Container.resolve("services.providers.#{provider}")
    end

    def sign_in(user)
      user_session = Authkeeper.configuration.user_session_model.constantize.create!(user: user)
      cookies[Authkeeper.configuration.access_token_name] = {
        value: generate_token.call(user_session: user_session)[:result],
        domain: Authkeeper.configuration.domain,
        expires: 1.week.from_now
      }.compact
    end
  end
end
