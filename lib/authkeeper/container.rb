# frozen_string_literal: true

require 'dry/auto_inject'
require 'dry/container'

module Authkeeper
  class Container
    extend Dry::Container::Mixin

    DEFAULT_OPTIONS = { memoize: true }.freeze

    class << self
      def register(key)
        super(key, DEFAULT_OPTIONS)
      end
    end

    register(:jwt_encoder) { Authkeeper::JwtEncoder.new }

    register('api.discord.auth_client') { Authkeeper::DiscordAuthApi::Client.new }
    register('api.discord.client') { Authkeeper::DiscordApi::Client.new }
    register('api.github.auth_client') { Authkeeper::GithubAuthApi::Client.new }
    register('api.github.client') { Authkeeper::GithubApi::Client.new }
    register('api.gitlab.auth_client') { Authkeeper::GitlabAuthApi::Client.new }
    register('api.gitlab.client') { Authkeeper::GitlabApi::Client.new }
    register('api.google.auth_client') { Authkeeper::GoogleAuthApi::Client.new }
    register('api.google.client') { Authkeeper::GoogleApi::Client.new }
    register('api.yandex.auth_client') { Authkeeper::YandexAuthApi::Client.new }
    register('api.yandex.client') { Authkeeper::YandexApi::Client.new }
    register('api.vk.auth_client') { Authkeeper::VkAuthApi::Client.new }

    register('services.providers.github') { Authkeeper::Providers::Github.new }
    register('services.providers.gitlab') { Authkeeper::Providers::Gitlab.new }
    register('services.providers.telegram') { Authkeeper::Providers::Telegram.new }
    register('services.providers.google') { Authkeeper::Providers::Google.new }
    register('services.providers.yandex') { Authkeeper::Providers::Yandex.new }
    register('services.providers.vk') { Authkeeper::Providers::Vk.new }
    register('services.providers.discord') { Authkeeper::Providers::Discord.new }

    register('services.fetch_uuid') { Authkeeper::FetchUuidService.new }
    register('services.fetch_session') { Authkeeper::FetchSessionService.new }
    register('services.generate_token') { Authkeeper::GenerateTokenService.new }
  end
end

AuthkeeperDeps = Dry::AutoInject(Authkeeper::Container)
