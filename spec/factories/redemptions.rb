FactoryBot.define do
  factory :redemption do
    transient do
      payment_value { nil }
    end

    payment
    debt
    association :author, factory: :egov_utils_user

    after(:build) do |redemption, evaluator|
      redemption.payment.value = evaluator.payment_value unless evaluator.payment_value.nil?
    end
  end
end
