class PaymentSchema < AzaharaSchema::ModelSchema

  def self.attribute(model, name, attr_type=nil)
    case name
    when 'value'
      AzaharaSchemaCurrency::CurrencyAttribute.new(model, name, 'currency', currency_code_method: 'currency_code')
    else
      super
    end
  end

  def main_attribute_name
    'payment_uid'
  end

end
