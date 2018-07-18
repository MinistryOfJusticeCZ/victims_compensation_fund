class StateBudgetItem < ApplicationRecord
  belongs_to :debt
  has_one :claim, through: :debt
  belongs_to :redemption, optional: true
  belongs_to :payment

  validates :redemption, presence: true, unless: :value?

  audited
  acts_as_paranoid

  before_validation(on: :create) do
    self.payment = Payment.new(value: value || redemption.payment.value)
  end
end
