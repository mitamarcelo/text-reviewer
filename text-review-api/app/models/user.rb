class User < ApplicationRecord
  include JwtRevoker
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  def jwt_payload
    { jti:, user: { name:, email: }, exp: 1.days.from_now.to_i }
  end
end
