module ApplicationHelper

  def show_money(value, currency_code='czk')
    return unless value
    case currency_code
    when 'czk'
      value.to_s + ' Kč'
    when 'usd'
      '$'+value.to_s
    when 'eur'
      value.to_s+'€'
    end
  end

end
