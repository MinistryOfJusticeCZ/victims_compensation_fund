require 'egov_utils/user_utils/role'

class DefaultOTCRole < EgovUtils::UserUtils::Role

  def define_abilities(ability, user)
    ability.can :read, :all
  end

end

class AdminRole < DefaultOTCRole

  add 'admin'

  def define_abilities(ability, user)
    ability.can :manage, :all
  end

end


class CourtEmployeeRole < DefaultOTCRole

  add 'court'

  def define_abilities(ability, user)
    super
    ability.can :manage, Redemption
    ability.can :create, Payment
    ability.can :create, Claim
    ability.can :create, Offender
    ability.can :create, Debt
  end

end

class CompensationDepartmentRole < DefaultOTCRole

  add 'compensator'

  def define_abilities(ability, user)
    super
    ability.can :manage, Appeal
    ability.can :manage, Claim
    ability.can :manage, Offender
    ability.can :manage, Debt
  end

end
