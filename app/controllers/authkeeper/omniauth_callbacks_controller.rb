# frozen_string_literal: true

module Authkeeper
  class OmniauthCallbacksController < ::ApplicationController
    include AuthkeeperDeps[
      fetch_session: 'services.fetch_session',
      generate_token: 'services.generate_token'
    ]

    DISCORD = 'discord'
    GITHUB = 'github'
    GITLAB = 'gitlab'
    TELEGRAM = 'telegram'
    GOOGLE = 'google'
    YANDEX = 'yandex'
    VK = 'vk'

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
      @auth ||=
        provider_service(params[:provider]).call(params: params.merge(oauth_data))[:result]
    end

    def oauth_data
      Rails.cache.read("oauth_data_#{params[:state]}") || {}
    end

    def provider_service(provider)
      Authkeeper::Container.resolve("services.providers.#{provider}")
    end
  end
end
