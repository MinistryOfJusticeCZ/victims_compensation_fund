class Satisfaction < ApplicationRecord
  belongs_to :payment, autosave: true, dependent: :destroy
  belongs_to :appeal
  has_many :fund_transfers, dependent: :destroy

  before_validation :set_payment_value, on: :create

  accepts_nested_attributes_for :fund_transfers, reject_if: :transfers_over_appeal_amount

  acts_as_paranoid

  # Deside if the attributes of this transfer won't go over appeal resting amount.
  #
  # In case it does, throws the transfer away.
  def transfers_over_appeal_amount(attributes)
    resting_amount = appeal.unsatisfied_amount - transfered_total
    return true if resting_amount < 0.0001
    transfered_value   = attributes['value']
    transfered_value ||= Redemption.find(attributes['redemption_id']).payment.value
    if appeal.unsatisfied_amount < transfered_value
      attributes['value'] = resting_amount
    end
    false
  end

  def transfered_total
    fund_transfers.sum{|ft| ft.satisfaction_value}
  end

  def set_payment_value
    p = self.payment || build_payment(direction: 'outgoing')
    p.direction ||= 'outgoing'
    p.value = transfered_total
  end

  def file_uid
    appeal.claim.file_uid
  end

end
