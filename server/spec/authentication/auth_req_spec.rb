# spec/auth/authorize_api_request_spec.rb
require 'rails_helper'
require 'support/controller_spec_helper'

RSpec.describe AuthReq do
  let(:user) { create(:user) }
  let(:header) { { 'Authorization' => token_generator(user.id) } }
  subject(:invalid_request_obj) { described_class.new({}) }
  subject(:request_obj) { described_class.new(header) }

  describe '#call' do
    context 'valid request' do
      it 'returns user obj' do
        result = request_obj.call
        expect(result[:user]).to eq(user)
      end
    end

    context 'invalid request' do
      context 'missing token' do
        it 'raises MissingToken' do
          expect { invalid_request_obj.call }.to raise_error(CustomException::MissingToken, 'Missing token')
        end
      end

      context 'invalid token' do
        subject(:invalid_request_obj) do
          described_class.new('Authorization' => token_generator(5))
        end

        it 'raises InvalidToken' do
          expect { invalid_request_obj.call }.to raise_error(CustomException::InvalidToken, /Invalid token/)
        end
      end

      context 'token expired' do
        let(:header) { { 'Authorization' => expired_token_generator(user.id) } }
        subject(:request_obj) { described_class.new(header) }


        # TODO: implement proper expired signature catch!!
        it 'raises ExceptionHandler::InvalidToken' do
          expect { request_obj.call }.to raise_error(CustomException::InvalidToken, /Signature has expired/)
        end
      end
    end
  end
end