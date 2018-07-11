module ClaimsHelper

  def claim_assignable_to(_claim)
    AssigneeAttribute.compensators
  end

end
