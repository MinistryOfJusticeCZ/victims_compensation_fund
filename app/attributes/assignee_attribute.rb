class AssigneeAttribute < AzaharaSchema::Attribute

  def self.compensators
    EgovUtils::User.where(lastname: 'Lidmilová')
  end

  def initialize(model, name)
    super(model, name, 'love')
  end

  def available_values
    @available_values ||= self.class.compensators.collect{|o| [o.fullname, o.id] }
  end

end
