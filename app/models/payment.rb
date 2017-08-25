class Payment < ApplicationRecord

  belongs_to :claim
  belongs_to :offender, class_name: 'Offender'
  belongs_to :author, class_name: 'EgovUtils::User'

  accepts_nested_attributes_for :claim
  accepts_nested_attributes_for :offender

  before_create :generate_uid

  private

    def generate_uid
      self.payment_uid = "#{Date.today.strftime("%Y%m")}#{id.to_s.rjust(4, "0")}"
    end

end
