class StateBudgetItemSchema < AzaharaSchema::ModelSchema

  filter_operators 'debt-offender-person-fullname', ['~']

  def main_attribute_name
    'payment-payment_uid'
  end

  def default_columns
    cols = ['debt-claim-file_uid', 'debt-offender-person-fullname', 'payment-value', 'payment-payment_uid', 'payment-status']
    cols << 'author-fullname' if EgovUtils::User.current.has_role?('compensator') || EgovUtils::User.current.has_role?('accountant')
    cols
  end

  def default_sort
    {'updated_at' => 'desc'}
  end

end
