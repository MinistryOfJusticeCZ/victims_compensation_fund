class RedemptionSchema < AzaharaSchema::ModelSchema


  def default_columns
    cols = ['debt-offender-fullname', 'payment-value', 'payment-currency_code']
    cols << 'author-fullname' if EgovUtils::User.current.has_role?('compensator')
    cols
  end

end
