class CourtUidAttribute < AzaharaSchema::Attribute

  def initialize(model, name)
    super(model, name, 'love')
  end

  def user_allowed_organization_keys(user=EgovUtils::User.current)
    user.organization_with_suborganizations_keys unless user.organization_key == '101000'
  end

  def user_allowed_organizations(user=EgovUtils::User.current)
    EgovUtils::Organization.courts(user_allowed_organization_keys(user))
  end

  def available_values
    @available_values ||= user_allowed_organizations.collect{|o| [o.name, o.key] }
  end

end
