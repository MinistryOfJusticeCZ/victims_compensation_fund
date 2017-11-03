class Debt < ApplicationRecord
  belongs_to :claim
  belongs_to :offender

  accepts_nested_attributes_for :claim
  accepts_nested_attributes_for :offender

  validates :value, numericality: true, allow_nil: true

  after_save :set_claim_status

  private
    def set_claim_status
      claim.set_status
    end
end
