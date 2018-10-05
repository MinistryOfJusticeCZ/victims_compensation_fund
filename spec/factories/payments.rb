FactoryBot.define do
  factory :payment do
    value { 1.5 }
    currency_code { 'czk' }
    status { nil }
    sequence(:payment_uid){|n| "88#{n.to_s.rjust(6, "0")}#{Time.now.strftime("%y")}"}
    uuid { nil }
  end
end
