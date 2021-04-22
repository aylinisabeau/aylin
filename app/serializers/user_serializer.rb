class UserSerializer < ApplicationSerializer
    attributes :id, :name, :email, :token, :created_at, :updated_at, :active_status, :last_login
end
