class AuthenticationSerializer < ApplicationSerializer
  attributes :id, :authentication_token, :authentication_token_expires_at, :email, :username
end
