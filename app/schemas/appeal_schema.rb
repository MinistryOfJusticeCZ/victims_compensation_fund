class AppealSchema < AzaharaSchema::ModelSchema

  filter_operators 'file_uid', ['~']
  filter_operators 'victim-fullname', ['~']

  def main_attribute_name
    'file_uid'
  end

  def default_columns
    ['file_uid', 'claim-court_uid', 'claim-file_uid', 'victim-fullname', 'offender-person-fullname', 'sum:satisfactions-payment-value']
  end

  def default_outputs
    ['grid']
  end

  def attribute_for_column(col)
    case col.name
    when 'payment_type'
      AzaharaSchema::Attribute.new(model, col.name, 'list')
    else
      super
    end
  end

  def enabled_filters
    ['claim_id', 'claim-file_uid', 'file_uid', 'victim-fullname']
  end

  def always_visible_filters
    ['claim-file_uid', 'file_uid', 'victim-fullname']
  end

end
