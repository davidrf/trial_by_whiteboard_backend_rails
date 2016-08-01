class AuthenticationSerializer < UserSerializer
  attributes :authentication_token, :authentication_token_expires_at, :email
end
