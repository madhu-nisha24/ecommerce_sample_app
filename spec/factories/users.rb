FactoryBot.define do
  factory :user do
    email { "MyString" }
    crypted_password { "MyString" }
    password_salt { "MyString" }
    persistence_token { "MyString" }
  end
end
