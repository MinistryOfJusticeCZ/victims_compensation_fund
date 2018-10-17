FactoryBot.define do
  factory :appeal do
    claim
    offender
    victim
    status { 1 }
    assigned_to { nil }
    file_uid { "MyString" }
    bank_account { "000000000000/0300" }
    payment_type { 1 }
  end
end
