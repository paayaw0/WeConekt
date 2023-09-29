FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    username { Faker::Internet.username }
    password { '@#hellOWorld_0' }
    email { 'paayaw.dev@gmail.com' }
  end
end
