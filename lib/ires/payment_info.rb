module Ires
  class PaymentInfo

    def initialize(payment_info={})
      @payment_info = payment_info
    end

    def payment_uuid
      @payment_info['id_zdroj_predpisu']
    end

    def prescription_status
      case @payment_info['stav_predpisu']
      when 'Z'
        paid? ? 'processed' : 'accepted'
      when 'O'
        'canceled'
      end
    end

    def infos
      @infos ||= Array.wrap(@payment_info['doklady']['doklad'])
    end

    def paid?
      infos.all?{|info| %w{D E}.include?(info['stav_dokladu']) && info['castka_zbyva'].to_f < 0.001 }
    end

  end
end
