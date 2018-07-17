class StateBudgetItem < ApplicationRecord
  belongs_to :debt
  has_one :claim, through: :debt
  belongs_to :redemption, optional: true
  belongs_to :payment, autosave: true

  validates :redemption, presence: true, unless: :value?

  audited
  acts_as_paranoid

  def value
    super || redemption.payment.value
  end

end
