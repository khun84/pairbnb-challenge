FactoryGirl.define do
    factory :reservation do
        check_in Date.new(2017,11,1)
        check_out Date.new(2017,11,3)
        num_of_guests 6
        user_id 1 # get from user object
        listing_id 1 # get from listing object
        status 'pending'
    end
end

