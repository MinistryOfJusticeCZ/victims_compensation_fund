require 'victims_compensation_fund/roles'

class Ability
  include CanCan::Ability

  def initialize(user)
    user.all_roles.each do |role|
      role.define_abilities(self)
    end
  end
end
