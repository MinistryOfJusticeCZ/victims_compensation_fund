class Debt < ApplicationRecord
  belongs_to :claim
  belongs_to :offender, class_name: 'Offender'

  accepts_nested_attributes_for :claim
  accepts_nested_attributes_for :offender
end
