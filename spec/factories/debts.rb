FactoryBot.define do
  factory :debt do
    claim
    offender
    value { "9.99" }
  end
end
