class FundTransfer < ApplicationRecord
  EPSILON = 0.00001

  belongs_to :redemption

  # it is going eighter to the state budget, or to satisfy a victim
  belongs_to :state_budget_item, optional: true
  belongs_to :satisfaction, optional: true

  validates :value, numericality: {less_than_or_equal_to: :redemption_payment_value}
  validate :redemption_not_transfered_over_its_value

  acts_as_paranoid

  before_validation :nullify_value_if_equals_redemption
  after_save :check_redemption_fully_processed

  def value
    super || redemption_payment_value
  end

  def satisfaction_value
    value
  end

  def budget_value
    [value - probation_value, 0.0].max
  end

  # If value is under 1,- it is all a probation value
  def probation_value
    [((value * 2.0) / 100).ceil, value].min
  end

  def redemption_payment_value
    redemption.payment.value
  end

  def transfered_to
    state_budget_item || satisfaction
  end

  private
    def nullify_value_if_equals_redemption
      val = read_attribute(:value)
      return true unless val
      if val && (val + EPSILON) > redemption_payment_value && (val - EPSILON) < redemption_payment_value
        self.value = nil
      end
      true
    end

    def redemption_not_transfered_over_its_value
      others = redemption.fund_transfers
      others = others.where(self.class.arel_table[:id].not_eq(id)) if persisted?
      others = others.sum{|ft| ft.value}
      if (others + value - 0.0001) > redemption_payment_value
        errors.add(:value, :over_redemption_value)
      end
    end

    def check_redemption_fully_processed
      if read_attribute(:value).nil? || ((redemption.fund_transfers.sum{|ft| ft.value} + 0.0001) > redemption_payment_value)
        redemption.update_columns(state: 'processed')
      else
        redemption.update_columns(state: 'waiting')
      end
    end
end
