require 'ires/message'
require 'ires/request'

module Ires
  class Sender

    def self.url
      "https://mspphaepo01.msp-pha.justice.cz:8443/iresois/IresOISService"
    end

    def self.message_for_payments(payments)
      Message.new(Savon.client(wsdl: self.url+'?wsdl'), payments.collect{|p| Ires::Request.new(p) })
    end

    def client
      @client ||= Savon.client(wsdl: self.class.url+'?wsdl')
    end


    def inner_message
      Message.new(client)
    end

  end
end
