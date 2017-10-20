class Appeal < ApplicationRecord

  belongs_to :claim
  belongs_to :victim, class_name: 'Victim'
  belongs_to :assigned_to, class_name: 'EgovUtils::User', optional: true
  has_many :satisfactions

  accepts_nested_attributes_for :claim
  accepts_nested_attributes_for :victim

  enum payment_type: { account: 1, foldout: 2 }

  validates :amount, numericality: true, allow_nil: true

  after_save :set_claim_status


  private
    def set_claim_status
      claim.set_status
    end
end
