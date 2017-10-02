FactoryGirl.define do
    factory :user do
        email 'daniel@gmail.com'
        name 'Daniel'
        country 'Malaysia'
        state 'Perak'
        role 'customer'
        password 'password'
    end
end