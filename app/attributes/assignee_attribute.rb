class AssigneeAttribute < AzaharaSchema::Attribute

  def self.compensators
    # TODO: extremely inefficient, will it be only case? thik about roles in separate table
    compensators_ids = Rails.cache.fetch("compensators_ids", expires_in: 1.day) do
      group_roles = EgovUtils::Group.all.to_a.select{|g| g.has_role?('compensator') }.collect{|g| g.members.pluck(:id) }.flatten
      group_roles.concat( EgovUtils::User.all.to_a.select{|u| u.has_role?('compensator')}.pluck(:id) )
    end
    EgovUtils::User.where(id: compensators_ids)
  end

  def initialize(model, name)
    super(model, name, 'love')
  end

  def available_values
    @available_values ||= self.class.compensators.collect{|o| [o.fullname, o.id] }
  end

end
