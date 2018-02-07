class Satisfaction < ApplicationRecord
  belongs_to :payment, dependent: :destroy
  belongs_to :appeal

  accepts_nested_attributes_for :payment

  before_validation :set_payment_direction, if: :new_record?

  acts_as_paranoid

  def file_uid
    appeal.file_uid
  end

  private

    def set_payment_direction
      self.payment.direction = 'outgoing'
    end
end
