require 'ires/message'
require 'ires/request'

require 'base64'
require 'signer'

class Signer
  def security_node
    @security_node ||= document.xpath('//wsse:Security', wsse: WSSE_NAMESPACE).first || document.root
  end

  def signature_algorithm_id
    @sign_digester.digest_id
  end
end

Settings['ires'] ||= SettingsLogic.new({})

module Ires
  class Sender

    def self.config
      Settings.ires
    end

    def self.url
      config.url
    end

    def self.sign_cert_file
      File.read(config.sign_cert_file)
    end
    def self.sign_cert_pkey_file
      File.read(config.sign_cert_pkey_file)
    end
    def self.sign_cert_pkey_password
      config.sign_cert_pkey_password
    end

    def client
      @client ||= Savon.client(wsdl: self.class.url+'?wsdl', ssl_verify_mode: :none)
    end

    def signed_message(message)
      # Rails.logger.debug message.to_xml if Object.const_defined?('Rails') && Rails.logger

      signer = Signer.new(message.to_xml)
      signer.cert = OpenSSL::X509::Certificate.new(self.class.sign_cert_file)
      signer.private_key = OpenSSL::PKey::RSA.new(self.class.sign_cert_pkey_file, self.class.sign_cert_pkey_password)

      signer.digest_algorithm = :sha256
      signer.signature_digest_algorithm = :sha256

      signer.digest!(signer.document.root, enveloped: true)
      # signer.digest!(signer.document.root.xpath('//ires:davka', {'ires' => 'http://iresois.cca.cz/'}).first, enveloped: true)
      signer.sign!(issuer_serial: true)

      Rails.logger.debug signer.to_xml if Object.const_defined?('Rails') && Rails.logger

      signer.to_xml
    end

    def send_payment_prescription(payment)
      payments = [payment].flatten
      message = Message.new(payments.collect{|p| Ires::Request.new(p) })

      base64_message = Base64.encode64(signed_message(message)).gsub("\n", '')

      Rails.logger.debug base64_message if Object.const_defined?('Rails') && Rails.logger

      client.call(:prijmi_predpis, message: {'prijmiPredpis' => { 'xmlData' => base64_message }})
    end


  end
end
