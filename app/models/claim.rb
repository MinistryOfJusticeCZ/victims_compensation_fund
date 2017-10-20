class Claim < ApplicationRecord

  validates :file_uid, uniqueness: true

  has_many :appeals
  has_many :debts

  validates :court_uid, inclusion: { in: :court_uids }

  def self.court_uids
    Organization.district_courts.collect{|c| c.abbrevation}
  end

end
