class CourtUidAttribute < AzaharaSchema::Attribute

  def available_values
    Organization.district_courts.collect{|o| [o.name,o.abbrevation] }
  end

end
