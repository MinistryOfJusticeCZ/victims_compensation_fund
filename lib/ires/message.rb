require 'gyoku'
require 'base64'
require 'securerandom'

module Ires
  class Message

    def system_code
      'FOTRC'
    end

    def organization_code
      '101000'
    end

    attr_reader :ires_requests

    def initialize(client, ires_requests)
      @client = client
      @ires_requests = ires_requests
    end

    def payment
      @payment
    end

    def inner_xml_hash
      {
        davka: {
          cislo_davky: SecureRandom.uuid,
          datum: Time.now.iso8601(3),
          system: system_code,
          organizace: organization_code,
          pozadavek: ires_requests.each_with_index.collect{|ireq,i| ireq.prescription_hash.merge(id_pozadavku: i+1, typ_pozadavku: ireq.request_type) }
        }
      }
    end

    def message_hash
      {'prijmiPredpisXml' => inner_xml_hash.merge('@xmlns'=>'http://iresois.cca.cz/', '@xmlns:ns2' => 'http://www.w3.org/2000/09/xmldsig#')}
    end

    def to_s
      Gyoku.xml(message_hash, key_converter: :underscore)
    end

    def signed_and_encoded

    end

  end
end
