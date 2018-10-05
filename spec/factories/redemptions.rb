FactoryBot.define do
  factory :redemption do
    payment
    debt
    association :author, factory: :egov_utils_user
  end
end
