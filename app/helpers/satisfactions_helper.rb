module SatisfactionsHelper

  def satisfaction_transfer_redemption_path(appeal, redemption)
    value = if appeal.unsatisfied_amount && appeal.unsatisfied_amount < redemption.payment.value
              appeal.unsatisfied_amount
            else
              value ||= redemption.payment.value
            end
    satisfactions_path(satisfaction: {appeal_id: appeal.id, fund_transfers_attributes: {'0' => {redemption_id: redemption.id, value: value}}})
  end

end
