FactoryBot.define do
  factory :offender do
    association :person, factory: :natural_person
    claim
  end
end
