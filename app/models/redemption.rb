class Redemption < ApplicationRecord
  belongs_to :payment
  belongs_to :debt
  has_one :claim, through: :debt
  belongs_to :author, class_name: 'EgovUtils::User'

  accepts_nested_attributes_for :payment
  accepts_nested_attributes_for :debt
end
