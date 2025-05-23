FactoryBot.define do
  factory :ok_sos_capacity, class: 'OkSos::Capacity' do
    capacity_id { Faker::Number.number(digits: 10) }
    description { ['Survivor', 'Acquiring', 'Acquired'].sample }
  end
end
