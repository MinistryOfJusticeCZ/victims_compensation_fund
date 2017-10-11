class PaymentSchema < AzaharaSchema::ModelSchema


  def default_columns
    cols = ['offender-fullname', 'value']
    cols << 'author-fullname' if EgovUtils::User.current.has_role?('compensator')
    cols
  end

end
