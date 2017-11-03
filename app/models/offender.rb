class Offender < ApplicationRecord
  belongs_to :person, class_name: 'EgovUtils::Person'
  belongs_to :claim
  has_many :appeals
  has_many :debts

  accepts_nested_attributes_for :person
end
