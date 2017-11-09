class OffenderSchema < AzaharaSchema::ModelSchema

  def searchable_attributes
    @searchable_attributes ||= available_attributes.select{|aa| aa.name == 'person-firstname' || aa.name == 'person-lastname' }
  end

end
