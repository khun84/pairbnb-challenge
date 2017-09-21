class User < ApplicationRecord
    include Clearance::User
    validates :name, presence: true, length: {maximum: 50}

    has_many :authentications
    has_many :listings
    has_many :reservations

    enum role:[:customer, :moderator, :admin]

    mount_uploader :avatar, AvatarUploader

    def self.create_with_auth_and_hash(authentication, auth_hash)
        user = self.create!(
           name: auth_hash['info']['name'],
           email: auth_hash['info']['email'],
           password: SecureRandom.hex(10)
        )
        user.authentications << authentication
        return user
    end

    # grab fb_token to access Facebook for user data
    def fb_token
        x = self.authentications.find_by(provider: 'facebook')
        return x.token unless x.nil?
    end
end
