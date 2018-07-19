class FundTransfer < ApplicationRecord
  belongs_to :redemption
  belongs_to :state_budget_item, optional: true
  belongs_to :satisfaction, optional: true

  validates :value, numericality: {less_than_or_equal_to: :redemption_payment_value}

  acts_as_paranoid

  def value
    super || redemption_payment_value
  end

  def redemption_payment_value
    redemption.payment.value
  end
end
