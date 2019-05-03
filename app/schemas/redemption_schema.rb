class RedemptionSchema < AzaharaSchema::ModelSchema

  filter_operators 'debt-offender-person-fullname', ['~']

  def main_attribute_name
    'payment-payment_uid'
  end

  def default_columns
    cols = ['debt-claim-file_uid', 'debt-offender-person-fullname', 'payment-value', 'payment-payment_uid']
    if EgovUtils::User.current.has_role?('accountant')
      cols.concat(['payment-status', 'author-fullname'])
    elsif EgovUtils::User.current.has_role?('compensator')
      cols.concat(['payment-paid_at', 'author-fullname'])
    else
      cols << 'payment-status'
    end
    cols
  end

  def enabled_filters
    efs = ['debt_id', 'debt-claim_id', 'payment-payment_uid', 'payment-status', 'debt-claim-file_uid', 'debt-offender-person-fullname', 'victim-fullname']
    efs << 'debt-claim-assigned_to_id'# if EgovUtils::User.current.has_role?('compensator')
    efs
  end

  def always_visible_filters
    ['debt-claim-file_uid', 'debt-offender-person-fullname', 'payment-payment_uid', 'debt-claim-assigned_to_id']
  end

  def default_sort
    {'created_at' => 'desc'}
  end

end
