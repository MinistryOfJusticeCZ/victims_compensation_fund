class Claim < ApplicationRecord

  validates :file_uid, uniqueness: true

  has_many :appeals
  has_many :payments

end
