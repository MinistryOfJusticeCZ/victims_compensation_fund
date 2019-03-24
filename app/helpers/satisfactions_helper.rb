module SatisfactionsHelper
  def satisfaction_transfer_amount(appeal, redemption)
    if appeal.unsatisfied_amount && appeal.unsatisfied_amount < redemption.payment.value
      appeal.unsatisfied_amount
    else
      value ||= redemption.payment.value
    end
  end

  def buton_to_satisfaction_transfer_redemption(appeal, redemption)
    amount = satisfaction_transfer_amount(appeal, redemption)
    button_to(
      t('label_transfer_amount_to_victim', victim: appeal.victim.fullname, amount: amount),
      satisfaction_transfer_redemption_path(appeal, redemption, amount),
      class: 'btn btn-secondary'
    )
  end

  def satisfaction_transfer_redemption_path(appeal, redemption, value = nil)
    value ||= satisfaction_transfer_amount(appeal, redemption)
    satisfactions_path(satisfaction: {appeal_id: appeal.id, fund_transfers_attributes: {'0' => {redemption_id: redemption.id, value: value}}})
  end
end
