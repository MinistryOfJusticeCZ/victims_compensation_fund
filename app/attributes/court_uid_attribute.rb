class CourtUidAttribute < AzaharaSchema::Attribute

  def user_allowed_organization_keys
    EgovUtils::User.current.organization_with_suborganizations_keys unless EgovUtils::User.current.organization_key == '101000'
  end

  def available_values
    @available_values ||= EgovUtils::Organization.courts(user_allowed_organization_keys).collect{|o| [o.name, o.key] }
  end

end
