module Ires
  module Requests
    class RequestCreate < Request

      def initialize(payment)
        super
        payment.uuid = SecureRandom.uuid
      end

      def request_type
        'P'
      end

      def action_type
        case payment.direction
        when 'incoming'
          'PŘEDEPSÁNO'
        when 'outgoing'
          'PŘEDEPSÁNO K ODŠKODNĚNÍ'
        end
      end

      def payment_type
        case payment.direction
        when 'incoming'
          'VÝNOSY Z TRESTNÍCH SANKCÍ'
        when 'outgoing'
          'ODŠKODNĚNÍ OBĚTÍ Z VTS'
        end
      end

      def purpose
        nil
      end

      def after_sent
        payment.status = 'sent'
        super
      end

      def optional_attributes_hash
        res = {}
        res.merge!(ucel: purpose) if purpose
        res.merge!(cislo_senatu: payment.file_uid.senat) if payment.file_uid.senat
        res.merge!(por_cislo: payment.file_uid.document_number) if payment.file_uid.document_number
        res
      end

      def person_attributes
        case payment.person.person_type
        when 'natural'
          {
            osoba_nazev: payment.person.natural_person.lastname,
            osoba_jmeno: payment.person.natural_person.firstname,
            osoba_datum_narozeni: payment.person.natural_person.birth_date.iso8601
          }
        when 'legal'
          {
            osoba_nazev: payment.person.legal_person.name,
            osoba_ic: payment.person.legal_person.ico
          }
        end
      end

      def ordering
        [
          :id_predpisu, :druh_akce, :druh_platby, :ucel,
          :bc_vec, :druh_vec, :cislo_senatu, :rocnik, :por_cislo,
          :osoba_nazev, :osoba_jmeno, :osoba_datum_narozeni, :osoba_ic, :osoba_rodne_cislo, :titul_pred, :titul_za,
          :castka, :mena, :datum_zapisu, :variabilni_symbol
        ]
      end

      def prescription_hash
        {
          id_predpisu: payment.uuid,
          druh_akce: action_type,
          druh_platby: payment_type,
          bc_vec: payment.file_uid.bc,
          druh_vec: payment.file_uid.agenda,
          rocnik: payment.file_uid.year,
          castka: format_payment_value(payment.value),
          mena: payment.currency_code.upcase,
          datum_zapisu: payment.updated_at.to_date.iso8601,
          variabilni_symbol: payment.payment_uid
        }.merge(optional_attributes_hash).merge(person_attributes)
      end

      def request_hash
        h = prescription_hash
        { predpis_zalozeni: h.merge(order!: ( ordering & h.keys )) }
      end

    end
  end
end
