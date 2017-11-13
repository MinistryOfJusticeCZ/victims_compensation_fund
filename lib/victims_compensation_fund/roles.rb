require 'egov_utils/user_utils/role'

class AdminRole < EgovUtils::UserUtils::Role

  add 'admin'

  def define_abilities(ability, user)
    ability.can :manage, :all
  end

end


class CourtEmployeeRole < EgovUtils::UserUtils::Role

  add 'court'

  def define_abilities(ability, user)
    ability.can :manage, Redemption
    ability.can :read, Payment
    ability.can :create, Payment

    ability.can :read, Claim
    ability.can :create, Claim

    ability.can :read, Offender
    ability.can :create, Offender
    ability.can :read, Debt
    ability.can :create, Debt
  end

end

class CompensationDepartmentRole < EgovUtils::UserUtils::Role

  add 'compensator'

  def define_abilities(ability, user)
    ability.can :read, :all
    ability.can :manage, Appeal
    ability.can :manage, Claim
    ability.can :manage, Offender
    ability.can :manage, Satisfaction
    ability.can :manage, Victim
    # ability.can :manage, Debt
  end

end
