class AppealSchema < AzaharaSchema::ModelSchema

  def main_attribute_name
    'file_uid'
  end

  def attribute_for_column(col)
    case col.name
    when 'payment_type'
      AzaharaSchema::Attribute.new(model, col.name, 'list')
    else
      super
    end
  end

end
