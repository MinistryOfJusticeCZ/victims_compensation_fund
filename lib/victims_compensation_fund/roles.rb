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
    ability.can :read, Payment
    ability.can :create, Payment

    if (org_keys = user.organization_with_suborganizations_keys).any?
      ability.can :read, Redemption, claim: { court_uid: org_keys }
      ability.can :read, Claim, court_uid: org_keys
    else
      ability.can :read, Redemption
      ability.can :read, Claim
    end
    ability.can :create, Redemption
    ability.can :create, Claim

    ability.can :read, Offender
    ability.can :create, Offender
    ability.can :read, Debt
    ability.can :create, Debt
    ability.can :read, EgovUtils::Person
    ability.can :create, EgovUtils::Person
    ability.can :create, EgovUtils::NaturalPerson
    ability.can :create, EgovUtils::LegalPerson
    ability.can :create, EgovUtils::Address
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
    ability.can :manage, EgovUtils::Person
    ability.can :manage, EgovUtils::NaturalPerson
    ability.can :manage, EgovUtils::LegalPerson
    ability.can :manage, EgovUtils::Address
    # ability.can :manage, Debt
  end

end

class AccountantRole < EgovUtils::UserUtils::Role
  add 'accountant'

  def define_abilities(ability, user)
    ability.can :read, Claim
    ability.can :read, Redemption
    ability.can :read, Payment
  end
end
