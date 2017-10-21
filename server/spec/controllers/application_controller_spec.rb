# spec/controllers/application_controller_spec.rb
require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  let!(:user) { create(:user) }
  let(:headers) { { 'Authorization' => token_generator(user.id) } }
  let(:invalid_headers) { { 'Authorization' => nil } }

  describe '#authorize_request' do
    context 'auth token supplied' do
      before { allow(request).to receive(:headers).and_return(headers) }

      # private method authorize_request returns current user
      # it 'sets current user' do
      #   expect(subject.instance_eval { auth_req }).to eq(user)
      # end
    end

    context 'no auth token supplied' do
      before do
        allow(request).to receive(:headers).and_return(invalid_headers)
      end

      it 'raises MissingToken' do
        expect { subject.instance_eval { auth_req } }.
            to raise_error(CustomException::MissingToken, /Missing token/)
      end
    end
  end
end