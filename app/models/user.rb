class User < ApplicationRecord
    has_secure_password

    attr_accessor :token

    validates :email, presence: true, uniqueness: true
    validates_length_of :password, maximum: 72, minimum: 5, allow_nil: true, allow_blank: false
    validates_confirmation_of :password, allow_nil: true, allow_blank: false

    def self.login params={}
        user = User.new
        if params[:email].empty? || params[:password].empty?
            user.errors.add(:base, I18n.t("error.messages.invalid_credentials"))
            return user
        end

        user = User.find_by_email(params[:email])
        if user && user.authenticate(params[:password])
            # Generate User token
            user.update last_login: Time.zone.now
            payload = {
                id: user.id,
                valid_until: user.last_login + 1.day
            }
            user.token = JWT.encode payload, Rails.application.credentials.secret_key_base, 'HS256'
            return user
        else
            user.errors.add(:base, I18n.t("error.messages.invalid_credentials"))
            return user
        end
    end
end
