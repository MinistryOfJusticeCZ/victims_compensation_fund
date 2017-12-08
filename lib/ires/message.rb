require 'gyoku'
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

    def initialize(ires_requests)
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
          pozadavek: ires_requests.each_with_index.collect{|ireq,i| {id_pozadavku: i+1, typ_pozadavku: ireq.request_type}.merge(ireq.prescription_hash) }
        }
      }
    end

    def message_hash
      {'prijmiPredpisXml' => inner_xml_hash.merge('@xmlns'=>'http://iresois.cca.cz/')}
    end

    def header_tag
      '<?xml version="1.0" encoding="UTF-8" standalone="no"?>'
    end

    def to_xml
      header_tag + Gyoku.xml(message_hash, key_converter: :none)
    end

  end
end
