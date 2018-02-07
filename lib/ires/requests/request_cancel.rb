module Ires
  module Requests
    class RequestCreate < Request

      def request_type
        'S'
      end

      def after_sent
        payment.status = 'canceled'
      end

      def request_hash
        { predpis_storno: {id_predpisu: payment.uuid} }
      end

    end
  end
end
