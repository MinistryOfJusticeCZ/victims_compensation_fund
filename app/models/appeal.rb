class Appeal < ApplicationRecord

  belongs_to :claim
  belongs_to :victim, class_name: 'Victim'
  belongs_to :assigned_to, class_name: 'EgovUtils::User', optional: true

  accepts_nested_attributes_for :claim
  accepts_nested_attributes_for :victim

  enum payment_type: { account: 1, foldout: 2 }

end
