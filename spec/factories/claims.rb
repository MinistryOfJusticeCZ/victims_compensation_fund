FactoryBot.define do
  factory :claim do
    binding_effect "2017-08-09 17:18:04"
    court_uid "205030"
    sequence(:file_uid) {|n| "27-T-#{n.to_s.rjust(4, '0')}/#{Date.today.year}"}
  end
end
