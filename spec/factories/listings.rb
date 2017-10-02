FactoryGirl.define do
    factory :listing do
        name 'property 1'
        smoke 'Y'
        base_price 200
        person_count 6
        user_id 1 # should get from user object
        pet 'Y'
        location_id 1 # should get from user object
        verified true
    end
end