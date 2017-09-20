# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


########### LOAD THE USER DATA
# (1..10).each do |i|
#     User.create(name: "test#{i}", email: "test#{i}@gmail.com", password: 'password')
# end

require 'csv'
########### LOAD THE LOCATION DATA
# user_ids = User.all.pluck(:id)
# location_path = File.join(File.dirname(__FILE__), 'location.csv')
# csv = CSV.new(File.open(location_path), headers:true)
# Location.transaction do
#     csv.each do |row|
#         location = Location.new
#         location.country = row["Country"]
#         location.state = row["State"]
#         location.city = row["City"]
#         location.save
#     end
# end

############# LOAD THE LISTING DATA
# location_ids = Location.all.pluck(:id)
#
# listing_path = File.join(File.dirname(__FILE__), 'listing.csv')
# csv = CSV.new(File.open(listing_path), headers:true)
# Listing.transaction do
#     csv.each do |row|
#         listing = Listing.new
#         data = row.to_h
#         listing.user_id = user_ids.sample
#         listing.name = data["property_name"]
#         listing.room_count = data["number_of_rooms"]
#         listing.location_id = location_ids.sample
#         # listing.country = data["country"]
#         # listing.state = data["state"]
#         # listing.city = data["city"]
#         listing.person_count = data["number_of_persons"]
#         listing.base_price = data["base_price"]
#         if data['smoking'] == '1'
#             listing.smoke = 'Y'
#         else
#             listing.smoke = 'N'
#         end
#         if data['pet'] == '1'
#             listing.pet = "Y"
#         else
#             listing.pet = "N"
#         end
#         listing.save
#     end
# end
User.transaction do
    User.all.each do |user|
        if user.email == 'khun84@gmail.com'
            user.moderator!
        else
            user.customer!
        end
    end
end