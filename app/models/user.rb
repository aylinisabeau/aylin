class User < ApplicationRecord
    has_secure_password

    attr_accessor :token

    validates :email, presence: true, uniqueness: true
    validates :password, presence: true
    validates_length_of :password, maximum: 72, minimum: 5, allow_nil: true, allow_blank: false
    validates_confirmation_of :password, allow_nil: true, allow_blank: false

    def self.login params={}
        user = User.new
        if params[:email].empty? || params[:password].empty?
            user.errors.add(:base, I18n.t("error.messages.invalid_credentials"))
            return user
        end

        user = User.find_by_email(params[:email])
        if user.nil?
            user.errors.add(:base, I18n.t("error.messages.invalid_credentials"))
            return user
        end
        password_digest = BCrypt::Password.create(params[:password])
        unless user.password == password_digest
            user.errors.add(:base, I18n.t("error.messages.invalid_credentials"))
            return user
        end

        # Generate User token
        payload = {
            id: user.id,
            valid_until: Time.zone.now + 1.day
        }
        user.token = JWT.encode payload, ENV['SECRET_KEY_BASE'], 'HS256'
        user.update last_login: Time.zone.now
        return user
    end
end
