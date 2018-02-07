require 'ires/requests/request_create'
require 'ires/requests/request_change'
require 'ires/requests/request_cancel'

module Ires
  module Requests
    class Request

      def self.for_payment(payment)
        if payment.uuid.nil?
          Ires::Requests::RequestCreate.new(payment)
        elsif payment.audits.last.audited_changes.key?('value')
          Ires::Requests::RequestChange.new(payment)
        elsif payment.deleted?
          Ires::Requests::RequestCancel.new(payment)
        else
          raise 'Unknown request type for payment.'
        end
      end

      attr_reader :payment

      def initialize(payment)
        @payment = payment
      end

      def format_payment_value(value)
        value.to_s
      end

      def after_sent
        payment.save
      end

      def request_hash
      end

    end
  end
end
