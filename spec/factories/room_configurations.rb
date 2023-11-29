FactoryBot.define do
  factory :room_configuration do
    user { nil }
    room { nil }
    disappearing_messages { "" }
    chat_lock_enabled { false }
    chat_lock_token { "MyString" }
  end
end
