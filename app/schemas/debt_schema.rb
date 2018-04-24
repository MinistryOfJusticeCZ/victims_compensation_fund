class DebtSchema < AzaharaSchema::ModelSchema

  def self.attribute(model, name, attr_type=nil)
    case name
    when 'value'
      AzaharaSchemaCurrency::CurrencyAttribute.new(model, name, 'currency')
    else
      super
    end
  end

  def main_attribute_name
    'offender-person-fullname'
  end

end
