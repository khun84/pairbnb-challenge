FactoryGirl.define do
    factory :user do
        email 'daniel@gmail.com'
        name 'Daniel'
        country 'Malaysia'
        state 'Perak'
        role 'customer'
        password 'password'
    end

    factory :user_moderator do
        email 'moderator@gmail.com'
        name 'moderator'
        country 'Malaysia'
        state 'Perak'
        role 'moderator'
        password 'password'
    end

end