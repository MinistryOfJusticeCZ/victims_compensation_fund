class AppealSchema < AzaharaSchema::ModelSchema

  filter_operators 'file_uid', ['~']
  filter_operators 'victim-fullname', ['~']

  def self.attribute(model, name, attr_type=nil)
    case name
    when 'payment_type'
      AzaharaSchema::Attribute.new(model, name, 'list')
    when 'amount'
      AzaharaSchemaCurrency::CurrencyAttribute.new(model, name, 'currency')
    else
      super
    end
  end

  def main_attribute_name
    'file_uid'
  end

  def default_columns
    ['file_uid', 'claim-court_uid', 'claim-file_uid', 'victim-fullname', 'offender-person-fullname', 'sum:satisfactions-payment-value']
  end

  def default_outputs
    ['grid']
  end

  def enabled_filters
    ['claim_id', 'claim-file_uid', 'file_uid', 'victim-fullname']
  end

  def always_visible_filters
    ['claim-file_uid', 'file_uid', 'victim-fullname']
  end

end
