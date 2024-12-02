# frozen_string_literal: true

describe Authkeeper::YandexApi::Client, type: :client do
  let(:headers) { { 'Content-Type' => 'application/json' } }
  let(:client) { described_class.new(connection: connection) }

  describe '.info' do
    subject(:client_request) { client.info(access_token: '123') }

    before do
      stubs.get('/info') { [status, headers, body.to_json] }
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
      let(:body) { { 'id' => 1 } }

      it 'returns user data' do
        expect(client_request).to eq body
      end
    end
  end
end
