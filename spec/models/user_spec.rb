require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
    describe 'create new user' do
        describe 'normal sign up' do
            context 'successful signup' do
                it 'should add the user to the database' do
                    user = create(:user)
                    user1 = User.find_by(email: user.email)
                    expect(user1.email).to eq user.email
                end
            end
        end
    end
end
