class Satisfaction < ApplicationRecord
  belongs_to :payment
  belongs_to :appeal

  accepts_nested_attributes_for :payment

  before_create :set_payment_direction

  private

    def set_payment_direction
      self.payment.direction = 'outcoming'
    end
end
