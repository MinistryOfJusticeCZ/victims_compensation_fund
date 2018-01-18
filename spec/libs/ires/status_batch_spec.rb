require 'spec_helper'

require 'base64'

require_dependency 'ires/status_batch'

RSpec.describe Ires::StatusBatch do

  let(:document){ doc = File.open('spec/libs/ires/data/prijmiInformaceOZaplaceni.xml') { |f| Nokogiri::XML(f) } }
  let(:encoded_message) { Base64.encode64 document.to_xml }
  let(:batch) { described_class.new(encoded_message) }

  it 'translates the document to proper xml' do
    expect(batch.xml).to be_a(Nokogiri::XML::Document)
    expect(batch.sent_at).to be_a(Time)
  end

  it 'parse all the payment_infos' do
    expect(batch.payment_infos.count).to eq(batch.xml.xpath('//urn2:predpisZpracovani', 'urn2' => 'http://common.iresois.cca.cz/').count)
  end

end
