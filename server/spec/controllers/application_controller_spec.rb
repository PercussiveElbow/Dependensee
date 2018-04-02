# spec/controllers/application_controller_spec.rb
require 'spec_helper'
RSpec.describe ApplicationController, type: :controller do
  let!(:user) { create(:user) }
  let(:headers) { { 'Authorization' => token_generator(user.id) } }
  let(:invalid_headers) { { 'Authorization' => nil } }

  describe '#authorize_request' do
    context 'auth token supplied' do
      before { allow(request).to receive(:headers).and_return(headers) }
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