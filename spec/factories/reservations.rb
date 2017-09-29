FactoryGirl.define do
    factory :reservation do
        check_in Date.new(2017,11,1)
        check_out Date.new(2017,11,3)
        num_of_guests 6
    end
end

