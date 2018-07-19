class StateBudgetItem < ApplicationRecord
  belongs_to :payment
  belongs_to :debt
  has_one :claim, through: :debt

  has_many :fund_transfers, dependent: :destroy

  audited
  acts_as_paranoid

  accepts_nested_attributes_for :fund_transfers
end
