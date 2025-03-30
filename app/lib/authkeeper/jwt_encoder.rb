# frozen_string_literal: true

module Authkeeper
  class JwtEncoder
    HMAC_SECRET = Rails.application.secret_key_base

    def encode(payload:, secret: HMAC_SECRET)
      JWT.encode(modify_payload(payload), secret)
    end

    def decode(token:, secret: HMAC_SECRET)
      JWT.decode(token, secret).first
    rescue JWT::DecodeError
      {}
    end

    def modify_payload(payload)
      payload.merge!(
        random: SecureRandom.hex,
        exp: DateTime.now.to_i + token_expiration_seconds
      )
    end

    private

    def token_expiration_seconds
      @token_expiration_seconds ||= Authkeeper.configuration.token_expiration_seconds
    end
  end
end
