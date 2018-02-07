module Ires
  module Requests
    class RequestChange < Request

      def request_type
        'A'
      end

      def after_sent
        payment.status = 'sent'
      end

      def request_hash
        { predpis_aktualizace: {id_predpisu: payment.uuid, castka: format_payment_value(payment.value)} }
      end

    end
  end
end
