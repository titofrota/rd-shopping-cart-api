FactoryBot.define do
  factory :cart do
    status { :active }
    last_interacted_at { Time.current }
    total_price { 100.0 }

    trait :abandoned do
      status { :abandoned }
    end

    trait :inactive_for_three_hours do
      last_interacted_at { 3.hours.ago }
    end

    trait :inactive_for_seven_days do
      last_interacted_at { 7.days.ago }
    end
  end
end
