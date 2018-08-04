class FundTransfer < ApplicationRecord
  belongs_to :redemption
  belongs_to :state_budget_item, optional: true
  belongs_to :satisfaction, optional: true

  validates :value, numericality: {less_than_or_equal_to: :redemption_payment_value}

  acts_as_paranoid

  after_save :check_redemption_fully_processed

  def value
    super || redemption_payment_value
  end

  def budget_value
    value - probation_value
  end

  def probation_value
    ((value * 2) / 100).ceil
  end

  def redemption_payment_value
    redemption.payment.value
  end

  private
    def check_redemption_fully_processed
      if read_attribute(:value).nil? || redemption.fund_transfers.sum{|ft| ft.value} + 0.001 > redemption_payment_value
        redemption.update(state: 'processed')
      else
        redemption.update(state: 'waiting')
      end
    end
end
