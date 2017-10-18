class Satisfaction < ApplicationRecord
  belongs_to :payment
  belongs_to :appeal
end
