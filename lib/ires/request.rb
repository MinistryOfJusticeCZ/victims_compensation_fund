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
      'PŘEDEPSÁNO'
    end

    def payment_type
      'SOUDNÍ POPLATKY'
    end

    def purpose
      nil
    end

    def optional_attributes_hash
      res = {}
      res.merge!(ucel: purpose) if purpose
      res.merge!(cislo_senatu: payment.file_uid.senat) if payment.file_uid.senat
      res.merge!(por_cislo: payment.file_uid.document_number) if payment.file_uid.document_number
      res
    end

    def prescription_hash
      {
        predpis_zalozeni: {
          id_predpisu: payment.uuid,
          druh_akce: action_type,
          druh_platby: payment_type,
          bc_vec: payment.file_uid.bc,
          druh_vec: payment.file_uid.agenda,
          rocnik: payment.file_uid.year,
          castka: payment.value,
          mena: payment.currency_code.upcase,
          datum_zapisu: payment.updated_at.to_time.iso8601(3),
          variabilni_symbol: payment.payment_uid
        }.merge(optional_attributes_hash)
      }
    end

  end
end
