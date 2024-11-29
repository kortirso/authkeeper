# frozen_string_literal: true

module Authkeeper
  module ApplicationHelper
    def omniauth_link(provider, oauth_data=nil)
      case provider
      when :github then github_oauth_link
      when :gitlab then gitlab_oauth_link
      when :google then google_oauth_link
      when :yandex then yandex_oauth_link
      when :vk then vk_oauth_link(oauth_data)
      end
    end

    private

    # rubocop: disable Layout/LineLength
    def github_oauth_link
      "https://github.com/login/oauth/authorize?scope=user:email&response_type=code&client_id=#{value(:github, :client_id)}&redirect_uri=#{value(:github, :redirect_url)}"
    end

    def gitlab_oauth_link
      "https://gitlab.com/oauth/authorize?scope=read_user&response_type=code&client_id=#{value(:gitlab, :client_id)}&redirect_uri=#{value(:gitlab, :redirect_url)}"
    end

    def google_oauth_link
      "https://accounts.google.com/o/oauth2/auth?scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.email&response_type=code&client_id=#{value(:google, :client_id)}&redirect_uri=#{value(:google, :redirect_url)}"
    end

    def yandex_oauth_link
      "https://oauth.yandex.ru/authorize?response_type=code&client_id=#{value(:yandex, :client_id)}"
    end

    def vk_oauth_link(oauth_data)
      "https://id.vk.com/authorize?scope=email&response_type=code&client_id=#{value(:vk, :client_id)}&code_challenge=#{oauth_data[:code_challenge]}&code_challenge_method=S256&redirect_uri=#{value(:vk, :redirect_url)}&state=#{oauth_data[:state]}"
    end
    # rubocop: enable Layout/LineLength

    def value(provider, key)
      Authkeeper.configuration.omniauth_configs.dig(provider, key)
    end
  end
end
