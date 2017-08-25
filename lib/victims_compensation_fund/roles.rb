require 'egov_utils/user_utils/role'

class AdminRole < EgovUtils::UserUtils::Role

  add 'admin'

  def define_abilities(ability)
    ability.can :manage, :all
  end

end


class CourtEmployeeRole < EgovUtils::UserUtils::Role

  add 'court'

  def define_abilities(ability)
    ability.can :manage, Payment
    ability.can :create, Claim
  end

end
