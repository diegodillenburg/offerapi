FactoryBot.define do
  factory :offer do
    sequence(:advertiser_name) { |n| "Advertiser #{n}" }
    url { "https://example.com" }
    description { "MyString" }
    starts_at { "2020-04-03 17:25:07" }
    ends_at { nil }
    premium { false }
    admin_state_override { false }
  end
end
