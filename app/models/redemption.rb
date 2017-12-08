class Redemption < ApplicationRecord
  belongs_to :payment
  belongs_to :debt
  has_one :claim, through: :debt
  belongs_to :author, class_name: 'EgovUtils::User'

  accepts_nested_attributes_for :payment
  accepts_nested_attributes_for :debt

  before_validation :set_payment_direction, if: :new_record?

  def file_uid
    claim.file_uid
  end

  private

    def set_payment_direction
      self.payment.direction = 'incoming'
    end
end
