class Satisfaction < ApplicationRecord
  belongs_to :payment
  belongs_to :appeal

  accepts_nested_attributes_for :payment

  before_validation :set_payment_direction, if: :new_record?

  private

    def set_payment_direction
      self.payment.direction = 'outcoming'
    end
end
