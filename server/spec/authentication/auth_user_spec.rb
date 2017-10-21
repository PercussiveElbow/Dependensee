# spec/auth/authenticate_user_spec.rb
require 'rails_helper'

RSpec.describe AuthUser do
  let(:user) { create(:user) }
  subject(:valid_auth_obj) { described_class.new(user.email, user.password) }
  subject(:invalid_auth_obj) { described_class.new('abc', '123') }

  describe '#call' do
    context 'valid creds' do
      it 'returns an auth token' do
        token = valid_auth_obj.call
        expect(token).not_to be_nil
      end
    end

    context 'invalid creds' do
      it 'raises auth error' do
        expect { invalid_auth_obj.call }.to raise_error(CustomException::AuthenticationError, /Invalid credentials/)
      end
    end
  end
end