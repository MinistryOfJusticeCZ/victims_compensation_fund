class StateBudgetItem < ApplicationRecord
  belongs_to :payment, autosave: true, dependent: :destroy
  belongs_to :debt
  has_one :claim, through: :debt

  has_many :fund_transfers, dependent: :destroy

  audited
  acts_as_paranoid

  accepts_nested_attributes_for :fund_transfers

  before_validation :set_payment_value, on: :create

  def transfered_total
    fund_transfers.sum{|ft| ft.budget_value}
  end

  def set_payment_value
    p = self.payment || build_payment(direction: 'outgoing')
    p.value = transfered_total
  end

  def file_uid
    claim.file_uid
  end
end
