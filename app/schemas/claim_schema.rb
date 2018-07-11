class ClaimSchema < AzaharaSchema::ModelSchema

  filter_operators 'file_uid', ['~']
  filter_operators 'court_uid', ['=']
  filter_operators 'appeals-victim-fullname', ['~']
  filter_operators 'debts-offender-person-fullname', ['~']

  def self.attribute_type(model, name, col=nil)
    if name == 'binding_effect'
      'date'
    else
      super
    end
  end

  def self.attribute(model, name, attr_type=nil)
    case name
    when 'court_uid'
      CourtUidAttribute.new(model, name)
    when 'assigned_to_id'
      AssigneeAttribute.new(model, name)
    else
      super
    end
  end

  def enabled_filters
    if EgovUtils::User.current.has_role?('court')
      ['file_uid', 'appeals-victim-fullname', 'debts-offender-person-fullname']
    else
      f = ['file_uid', 'court_uid', 'appeals-victim-fullname', 'debts-offender-person-fullname', 'status']
      f << 'assigned_to_id' if EgovUtils::User.current.has_role?('compensator')
      f
    end
  end

  def always_visible_filters
    ['court_uid', 'file_uid', 'appeals-victim-fullname', 'debts-offender-person-fullname', 'status']
  end

  def default_outputs
    ['grid']
  end

  def default_columns
    ['court_uid', 'file_uid', 'status']
  end

end
