require 'base64'
require 'nokogiri'

require 'ires/payment_info'
require 'ires/sender'

module Ires
  class StatusBatch

    attr_reader :xml

    def ois_namespace
      'http://ois.cca.cz/'
    end

    def common_namespace
      'http://common.iresois.cca.cz/'
    end

    def sender
      @sender ||= ::Ires::Sender.new
    end

    def initialize(message)
      decoded_message = Base64.decode64(message)
      @xml = Nokogiri::XML( decoded_message )
    end

    def sent_at
      @sent_at ||= xml.xpath('//urn:davka/urn:datum', 'urn' => ois_namespace).first.content.to_time
    end

    def payment_infos
      return @payment_infos if @payment_infos
      parser = Nori.new(convert_tags_to: lambda { |tag| tag.snakecase }, strip_namespaces: true)
      @payment_infos ||= xml.xpath('//urn2:predpisZpracovani', 'urn2' => common_namespace).collect do |predpis_node|
          ::Ires::PaymentInfo.new(parser.parse(predpis_node.to_xml)['predpis_zpracovani'])
        end
    end

    def header_tag
      '<?xml version="1.0" encoding="UTF-8" standalone="no"?>'
    end
    def inner_response_hash
      { 'urn2:statusOperace' => {'urn2:vysledek' => true} }
    end
    def response_hash
      {'prijmiInformaceOZaplaceniXmlResponse' => inner_response_hash.merge('@xmlns' => ois_namespace, '@xmlns:urn2'=>common_namespace)}
    end

    def response
      header_tag + Gyoku.xml(response_hash, key_converter: :none)
    end

    def signed_response(sender=self.sender)
      res = sender.signed_message(response, inclusive_namespaces: ['urn2'])
      sender.validate_response(res)
      res
    end

    def encoded_signed_response
      Base64.encode64(signed_response).gsub("\n", '')
    end

  end
end
