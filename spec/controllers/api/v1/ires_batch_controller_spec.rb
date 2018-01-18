require 'rails_helper'

RSpec.describe Api::V1::IresBatchController, type: :controller do

  describe '#create' do
    let(:document){ doc = File.open('spec/libs/ires/data/prijmiInformaceOZaplaceni.xml') { |f| Nokogiri::XML(f) } }
    let(:encoded_message) { Base64.encode64 document.to_xml }

    it 'sends response' do
      post :create, params: { xml_data: encoded_message }
      expect( JSON.parse(response.body).keys ).to include('return')
    end

  end

end