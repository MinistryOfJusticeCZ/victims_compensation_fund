class FundTransfer < ApplicationRecord
  belongs_to :redemption
  belongs_to :state_budget_item
  belongs_to :satisfaction

  validates :value, numericality: {less_than_or_equal_to: :redemption_payment_value}

  acts_as_paranoid

  def value
    value || redemption_payment_value
  end

  def redemption_payment_value
    redemption.payment.value
  end
end
