FactoryBot.define do
  factory :state_budget_item do
    debt
    redemption
    payment
    due_at { Date.today + 5.days }
  end
end
