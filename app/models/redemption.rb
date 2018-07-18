class Redemption < ApplicationRecord
  belongs_to :payment, dependent: :destroy
  belongs_to :debt
  has_one :claim, through: :debt
  belongs_to :author, class_name: 'EgovUtils::User'

  accepts_nested_attributes_for :payment
  accepts_nested_attributes_for :debt

  has_many :fund_transfers

  before_validation :set_payment_direction, if: :new_record?

  acts_as_paranoid

  scope :unprocessed, ->(boundary=Date.today-boundary_days) {
    joins(:claim).where(
      Claim.arel_table[:binding_effect].lteq(boundary).or(
        Claim.arel_table[:binding_effect].eq(nil).and(arel_table[:created_at].lteq(boundary))
      )
    )
  }

  cattr_accessor :boundary_days
  self.boundary_days = 60.days

  def unprocessed?
    if claim.binding_effect
      claim.binding_effect <= Date.today - self.class.boundary_days
    else
      created_at <= Date.today - self.class.boundary_days
    end
  end

  def file_uid
    claim.file_uid
  end

  private

    def set_payment_direction
      self.payment.direction = 'incoming'
    end
end
