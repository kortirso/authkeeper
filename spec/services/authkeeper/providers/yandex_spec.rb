# frozen_string_literal: true

describe AuthContext::Providers::Yandex do
  subject(:service_call) { described_class.new.call(params: { code: code }) }

  let(:code) { 'code' }
  let(:user_response) { { 'id' => '123', 'default_email' => 'email' } }

  before do
    allow(Backend::Container.resolve('api.yandex.auth_client')).to(
      receive(:fetch_access_token).and_return(token_response)
    )
    allow(Backend::Container.resolve('api.yandex.client')).to(
      receive(:info).and_return(user_response)
    )
  end

  context 'if code is invalid' do
    let(:token_response) { nil }

    it 'returns nil result', :aggregate_failures do
      expect(service_call[:result]).to be_nil
      expect(service_call[:errors]).not_to be_empty
    end

    context 'if code is valid' do
      let(:token_response) { { 'access_token' => 'access_token' } }

      it 'returns result and succeeds', :aggregate_failures do
        expect(service_call[:result]).to eq({
          auth_info: {
            access_token: 'access_token'
          },
          user_info: {
            uid: '123',
            provider: 'yandex',
            username: nil,
            email: 'email',
            phone_number: nil
          }
        })
        expect(service_call[:errors]).to be_nil
      end
    end
  end
end
