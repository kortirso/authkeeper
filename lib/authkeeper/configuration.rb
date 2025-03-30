# frozen_string_literal: true

module Authkeeper
  class Configuration
    InitializeError = Class.new(StandardError)

    attr_accessor :user_model, :user_session_model, :access_token_name, :domain, :fallback_url_session_name, :omniauth_providers
                  :token_expiration_seconds
    attr_reader :omniauth_configs

    def initialize
      @user_model = 'User'
      @user_session_model = 'User::Session'

      @access_token_name = nil
      @domain = nil
      @fallback_url_session_name = nil

      @omniauth_providers = []
      @omniauth_configs = {}

      @token_expiration_seconds = 18_144_000 # 30.days
    end

    def validate
      raise InitializeError, 'User model must be present' if user_model.nil?
      raise InitializeError, 'User session model must be present' if user_session_model.nil?
      raise InitializeError, 'Access token name must be present' if access_token_name.nil?
    end

    def omniauth(provider, **args)
      @omniauth_configs[provider] = args
    end
  end
end
