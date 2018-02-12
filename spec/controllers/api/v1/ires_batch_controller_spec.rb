require 'rails_helper'

RSpec.describe Api::V1::IresBatchController, type: :controller do

  describe '#create' do
    let(:document){ File.open(message_file){ |f| Nokogiri::XML(f) } }
    let(:encoded_message) { Base64.encode64 document.to_xml }

    before(:each) do
      sender = double('sender')
      expect_any_instance_of(Ires::StatusBatch).to receive(:sender).and_return(sender)
      expect(sender).to receive(:signed_message) do |message|
        message
      end
      expect(sender).to receive(:validate_response).and_return(true)
    end

    context 'with test file' do
      let(:message_file){ 'spec/libs/ires/data/prijmiInformaceOZaplaceni.xml' }
      let(:payment){ FactoryBot.create(:payment, uuid: '788d5c2a-43f1-43f5-95fe-b158b69d9f8c', status: 'sent') }
      it 'sends response' do
        payment;
        post :create, params: { xml_data: encoded_message }
        expect( JSON.parse(response.body).keys ).to include('return')
      end

      pending 'should fail gracefully - without existing payment' do
        post :create, params: { xml_data: encoded_message }
        expect( JSON.parse(response.body).keys ).to include('error')
      end
    end
    context 'with real data' do
      let(:message_file){ 'spec/libs/ires/data/prijmiInformaceOZaplaceni2.xml' }
      let(:payment1){ instance_double('Payment', uuid: 'fd736776-3754-44d2-931f-2e2fde8085bc', status: 'sent') }
      let(:payment2){ instance_double('Payment', uuid: '6af5289b-4791-4bd6-bd1d-6fd95a61c90b', status: 'sent') }

      it 'sends response - real data' do
        expect(Payment).to receive(:find_by).with(hash_including(uuid: payment1.uuid)).and_return(payment1)
        expect(Payment).to receive(:find_by).with(hash_including(uuid: payment2.uuid)).and_return(payment2)
        expect(payment1).not_to receive(:update_column)
        expect(payment2).to receive(:update_column).with(:status, 'processed')

        post :create, params: { xml_data: encoded_message }
        expect( JSON.parse(response.body).keys ).to include('return')
      end
    end



  end

end
