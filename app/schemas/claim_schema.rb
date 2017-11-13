class ClaimSchema < AzaharaSchema::ModelSchema

  filter_operators 'file_uid', ['~']
  filter_operators 'court_uid', ['=']
  filter_operators 'appeals-victim-fullname', ['~']
  filter_operators 'debts-offender-person-fullname', ['~']

  def enabled_filters
    if EgovUtils::User.current.has_role?('court')
      ['file_uid', 'appeals-victim-fullname', 'debts-offender-person-fullname']
    else
      ['file_uid', 'court_uid', 'appeals-victim-fullname', 'debts-offender-person-fullname', 'status']
    end
  end

  def always_visible_filters
    ['court_uid', 'file_uid', 'appeals-victim-fullname', 'debts-offender-person-fullname', 'status']
  end

  def attribute_for_column(col)
    case col.name
    when 'court_uid'
      CourtUidAttribute.new(model, col.name, 'love')
    when 'status'
      AzaharaSchema::Attribute.new(model, col.name, 'list')
    else
      super
    end
  end

end
