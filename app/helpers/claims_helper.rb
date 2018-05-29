module ClaimsHelper

  def claim_assignable_to(_claim)
    EgovUtils::User.where(lastname: 'Lidmilová')
  end

end
