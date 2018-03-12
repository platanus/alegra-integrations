FactoryGirl.define do
  factory :document do
    document_type "MyString"
    bsale_id 1
    alegra_id 1
    rut "76.191.257-7"
    date Date.new(1982, 3, 3)
    amount 35000

    trait :sale do
      document_type :sale
    end

    trait :buy do
      document_type :buy
    end
  end
end
