FactoryGirl.define do
  factory :redemption do
    payment
    debt
    author { User.current }
  end
end
