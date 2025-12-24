# frozen_string_literal: true

module Authkeeper
  class FetchUuidService
    include AuthkeeperDeps[jwt_encoder: 'jwt_encoder']

    def call(token:)
      payload = extract_uuid(token)
      return { errors: ['Forbidden'] } if payload.blank?
      return { errors: ['Forbidden'] } if payload['uuid'].blank?

      { result: payload['uuid'] }
    end

    private

    def extract_uuid(token)
      jwt_encoder.decode(token: token)
    end
  end
end
