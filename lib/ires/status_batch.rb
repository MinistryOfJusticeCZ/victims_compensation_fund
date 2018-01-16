require 'base64'

module Ires
  class StatusBatch

    def initialize(message)
      decoded_message = Base64.decode64(message)
      @xml = Nokogiri::XML( decoded_message )
    end

  end
end
