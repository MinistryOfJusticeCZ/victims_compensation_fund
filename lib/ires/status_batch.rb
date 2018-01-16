require 'base64'

module Ires
  class StatusBatch

    def initialize(message)
      @xml = Nokogiri::XML( Base64.decode64(message) )
    end

  end
end
