class Satisfaction < ApplicationRecord
  belongs_to :payment, dependent: :destroy
  belongs_to :appeal
  has_many :fund_transfers, dependent: :destroy

  before_validation :set_payment_direction, on: :create
  before_validation :set_payment_value, on: :create

  accepts_nested_attributes_for :fund_transfers

  acts_as_paranoid


  def transfered_total
    fund_transfers.sum{|ft| ft.budget_value}
  end

  def set_payment_value
    p = self.payment || build_payment(direction: 'outgoing')
    p.value = transfered_total
  end

  def file_uid
    appeal.file_uid
  end

  private

    def set_payment_direction
      self.payment.direction = 'outgoing'
    end
end
