require 'ires/message'

module Ires
  class Sender

    def self.url
      "https://mspphaepo01.msp-pha.justice.cz:8443/iresois/IresOISService"
    end

    def client
      @client ||= Savon.client(wsdl: self.class.url+'?wsdl')
    end

    def inner_message
      Message.new(client)
    end

  end
end
