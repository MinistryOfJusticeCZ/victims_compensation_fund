require 'ires/message'
require 'ires/request'

require 'base64'
require 'signer'
require 'securerandom'

class IresSigner < Signer
  def security_node
    @security_node ||= document.xpath('//wsse:Security', wsse: WSSE_NAMESPACE).first || document.root
  end

  def signature_algorithm_id
    @sign_digester.signature_id
  end

  def cert_encoded_issuer
    cert.issuer.to_a.reverse.collect{|component| (component[0] + '=' + component[1]).force_encoding('UTF-8') }.join(',')
  end
  def cert_encoded_subject
    cert.subject.to_a.reverse.collect{|component| (component[0] + '=' + component[1]).force_encoding('UTF-8') }.join(',')
  end

  def x509_data_node(issuer_in_security_token = false)
    # issuer_name_node   = Nokogiri::XML::Node.new('X509IssuerName', document)
    # issuer_name_node.content = cert_encoded_issuer

    # issuer_number_node = Nokogiri::XML::Node.new('X509SerialNumber', document)
    # issuer_number_node.content = cert.serial

    # issuer_serial_node = Nokogiri::XML::Node.new('X509IssuerSerial', document)
    # issuer_serial_node.add_child(issuer_name_node)
    # issuer_serial_node.add_child(issuer_number_node)

    issuer_serial_node = Nokogiri::XML::Node.new('X509SubjectName', document)
    issuer_serial_node.content = cert_encoded_subject

    cetificate_node    = Nokogiri::XML::Node.new('X509Certificate', document)
    cetificate_node.content = Base64.encode64(cert.to_der).gsub("\n", '')

    data_node          = Nokogiri::XML::Node.new('X509Data', document)
    data_node.add_child(issuer_serial_node)
    data_node.add_child(cetificate_node)

    if issuer_in_security_token
      security_token_reference_node = Nokogiri::XML::Node.new("wsse:SecurityTokenReference", document)
      security_token_reference_node.add_child(data_node)
    end

    key_info_node      = Nokogiri::XML::Node.new('KeyInfo', document)
    key_info_node.add_child(issuer_in_security_token ? security_token_reference_node : data_node)

    signed_info_node.add_next_sibling(key_info_node)

    set_namespace_for_node(key_info_node, DS_NAMESPACE, ds_namespace_prefix)
    set_namespace_for_node(security_token_reference_node, WSSE_NAMESPACE, ds_namespace_prefix) if issuer_in_security_token
    set_namespace_for_node(data_node, DS_NAMESPACE, ds_namespace_prefix)
    set_namespace_for_node(issuer_serial_node, DS_NAMESPACE, ds_namespace_prefix)
    set_namespace_for_node(cetificate_node, DS_NAMESPACE, ds_namespace_prefix)
    # set_namespace_for_node(issuer_name_node, DS_NAMESPACE, ds_namespace_prefix)
    # set_namespace_for_node(issuer_number_node, DS_NAMESPACE, ds_namespace_prefix)

    data_node
  end
end

Signer::DIGEST_ALGORITHMS[:sha256][:signature_id] = 'http://www.w3.org/2001/04/xmldsig-more#rsa-sha256'
Signer::DIGEST_ALGORITHMS[:sha256][:id] = 'http://www.w3.org/2001/04/xmlenc#sha256'

class Signer::Digester

  def signature_id
    @digest_info[:signature_id]
  end

end



EgovUtils::Settings['ires'] ||= Settingslogic.new({})

module Ires
  class Sender

    def self.config
      EgovUtils::Settings.ires
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
      @client ||= Savon.client(wsdl: self.class.url+'?wsdl', log: :true, log_level: :info, ssl_verify_mode: :none)
    end

    def validate_prescription(message_xml)
      xsd = Nokogiri::XML::Schema(File.open(Rails.root.join('data', 'ires', 'prijmiPredpisIresOIS.xsd')))
      xsd.validate(Nokogiri::XML(message_xml)).each do |error|
        puts error.message
      end
    end

    def validate_response(message_xml)
      xsd = Nokogiri::XML::Schema(File.open(Rails.root.join('data', 'ires', 'prijmiInformaceOZaplaceniResponseOIS.xsd')))
      xsd.validate(Nokogiri::XML(message_xml)).each do |error|
        puts error.message
      end
    end

    def certificate
      OpenSSL::X509::Certificate.new(self.class.sign_cert_file)
    end
    def certificate_pkey
      OpenSSL::PKey::RSA.new(self.class.sign_cert_pkey_file, self.class.sign_cert_pkey_password)
    end

    def signed_message(message)

      signer = IresSigner.new(message)
      signer.cert = certificate
      signer.private_key = certificate_pkey

      signer.digest_algorithm = :sha256
      signer.signature_digest_algorithm = :sha256

      signer.digest!(signer.document, enveloped: true, id: '')
      # signer.digest!(signer.document.root.xpath('//ires:davka', {'ires' => 'http://iresois.cca.cz/'}).first, enveloped: true)
      signer.sign!(issuer_serial: true)


      signer.to_xml
    end

    def signed_xml_message(message)
      signed_message(message.to_xml)
    end

    def send_prescription!(organization_code, job_id)
      payments = Payment.for_organization(organization_code).where( uuid: nil )

      message = Message.new(organization_code, job_id, payments.collect{|p| Ires::Request.new(p) })

      signed_message = signed_message(message.to_xml)
      validate_prescription(signed_message)

      base64_message = Base64.encode64(signed_message).gsub("\n", '')

      response = client.call(:prijmi_predpis, message: {'tns:xmlData' => base64_message })
      Rails.logger.info response.body
      payments.each {|p| p.save }
    end


  end
end
