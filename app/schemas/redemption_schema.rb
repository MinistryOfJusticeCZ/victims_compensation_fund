class RedemptionSchema < AzaharaSchema::ModelSchema

  filter_operators 'debt-offender-person-fullname', ['~']

  def default_columns
    cols = ['debt-claim-file_uid', 'debt-offender-person-fullname', 'payment-value', 'payment-currency_code', 'payment-payment_uid']
    cols << 'author-fullname' if EgovUtils::User.current.has_role?('compensator')
    cols
  end

  def enabled_filters
    ['debt-claim_id', 'debt-claim-file_uid', 'debt-offender-person-fullname', 'victim-fullname']
  end

  def always_visible_filters
    ['debt-claim-file_uid', 'debt-offender-person-fullname', 'victim-fullname']
  end

end
