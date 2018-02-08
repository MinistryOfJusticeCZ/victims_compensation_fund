module Ires
  module Requests
    class RequestCancel < Request

      def request_type
        'S'
      end

      def after_sent
        payment.update_columns(status: 'canceled')
      end

      def request_hash
        { predpis_storno: {id_predpisu: payment.uuid} }
      end

    end
  end
end
