class Payment < ApplicationRecord

  belongs_to :claim
  belongs_to :offender, class_name: 'Offender'
  belongs_to :author, class_name: 'EgovUtils::User'

  accepts_nested_attributes_for :claim
  accepts_nested_attributes_for :offender

  after_create :generate_uid

  validates :value, numericality: true

  private

    def generate_uid
      self.update_column(:payment_uid, "#{Time.now.strftime("%y")}#{id.to_s.rjust(8, "0")}")
    end

end
