module SatisfactionsHelper

  def satisfaction_transfer_redemption_path(appeal, redemption)
    value = appeal.unsatisfied_amount if appeal.unsatisfied_amount < redemption.payment.value
    satisfactions_path(satisfaction: {appeal_id: appeal.id, fund_transfers_attributes: {'0' => {redemption_id: redemption.id, value: value}}})
  end

end
