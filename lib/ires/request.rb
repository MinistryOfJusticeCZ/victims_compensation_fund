module Ires
  class Request

    attr_reader :payment

    def initialize(payment)
      @payment = payment
    end

    def request_type
      'P'
    end

    def action_type

    end

    def payment_type

    end

    def purpose
      ''
    end

    def prescription_hash
      {
        predpis_zalozeni: {
          id_predpisu: payment.uuid,
          druh_akce: action_type,
          druh_platby: payment_type,
          ucel: purpose,
          bc_vec: payment.file_uid.bc,
          druh_vec: payment.file_uid.agenda,
          cislo_senatu: payment.file_uid.senat,
          rocnik: payment.file_uid.year,
          por_cislo: payment.file_uid.document_number,
          castka: payment.value,
          mena: payment.currency_code.upper,
          datum_zapisu: payment.updated_at.to_time.iso8601(3),
          variabilni_symbol: payment.payment_uid
        }
      }
    end

  end
end
