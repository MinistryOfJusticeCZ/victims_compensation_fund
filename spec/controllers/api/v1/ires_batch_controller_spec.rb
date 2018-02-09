require 'rails_helper'

RSpec.describe Api::V1::IresBatchController, type: :controller do

  describe '#create' do
    let(:document){ doc = File.open('spec/libs/ires/data/prijmiInformaceOZaplaceni.xml') { |f| Nokogiri::XML(f) } }
    let(:payment){ FactoryBot.create(:payment, uuid: '788d5c2a-43f1-43f5-95fe-b158b69d9f8c', status: 'sent') }
    let(:encoded_message) { Base64.encode64 document.to_xml }

    before(:each) do
      sender = double('sender')
      expect_any_instance_of(Ires::StatusBatch).to receive(:sender).and_return(sender)
      expect(sender).to receive(:signed_message) do |message|
        message
      end
    end

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

end
