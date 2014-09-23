FactoryGirl.define do
  factory :user do
    sequence(:username)   { |n| "User_#{n}" }
    sequence(:email)      { |n| "user#{n}@example.com" }
    password              "password"
    password_confirmation "password"

    factory :confirmed_user do
      after(:create) { |user| user.confirm! }
    end
  end
end
