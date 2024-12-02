# frozen_string_literal: true

describe Authkeeper::YandexAuthApi::Client, type: :client do
  let(:headers) { { 'Content-Type' => 'application/x-www-form-urlencoded' } }
  let(:client) { described_class.new(connection: connection) }

  describe '.fetch_access_token' do
    subject(:client_request) { client.fetch_access_token(client_id: '1', client_secret: '2', code: '3') }

    before do
      stubs.post('/token') { [status, headers, body.to_json] }
    end

    context 'for invalid response' do
      let(:status) { 403 }
      let(:errors) { [{ 'detail' => 'Forbidden' }] }
      let(:body) { { 'errors' => errors } }

      it 'returns nil' do
        expect(client_request).to be_nil
      end
    end

    context 'for valid response' do
      let(:status) { 200 }
      let(:body) { { 'access_token' => 'access_token' } }

      it 'returns user data' do
        expect(client_request).to eq body.to_json
      end
    end
  end
end
