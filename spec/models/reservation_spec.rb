require 'rails_helper'

RSpec.describe Reservation, type: :model do
    describe 'create reservation' do

        before(:each) do
            @host = create(:user)
            @guest = create(:user, name: 'guest', email: 'guest@gmail.com')
            @location = create(:location)
            @listing = create(:listing, user_id: @host.id, location_id: @location.id)
        end

        context 'with valid input' do
            it 'should successfully create the reservation' do
                reservation = create(:reservation, user_id: @guest.id, listing_id: @listing.id)
                expect(reservation.id.nil?).to be false
            end
        end

        context 'with invalid input' do

            it 'should reject check out date earlier than check in date' do

                expect{
                    create(:reservation,
                           user_id: @guest.id,
                           listing_id: @listing.id,
                           check_in: Date.today,
                           check_out: Date.today - 1.day)
                }.to raise_error ActiveRecord::RecordInvalid
            end

            it 'should reject overlapped reservation' do
                reservation = create(:reservation, user_id: @guest.id, listing_id: @listing.id)
                reservation.status = 'confirmed'
                reservation.save
                expect{create(:reservation,
                              user_id: @guest.id,
                              listing_id: @listing.id,
                       )}.to raise_error ActiveRecord::RecordInvalid
            end

            it 'should reject when guests are more than allowed' do
                expect{
                    create(:reservation, user_id: @guest.id, listing_id: @listing.id, num_of_guests: @listing.person_count + 1)
                }.to raise_error ActiveRecord::RecordInvalid
            end

            it 'should only be booked by customer only' do
                moderator = create(:user, role: 'moderator', name: 'moderator', email: 'moderator@gmail.com')

                expect{
                    create(:reservation, user_id: moderator.id, listing_id: @listing.id, num_of_guests: @listing.person_count)
                }.to raise_error ActiveRecord::RecordInvalid
            end

        end
    end
end
