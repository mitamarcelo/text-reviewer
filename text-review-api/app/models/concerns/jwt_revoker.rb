module JwtRevoker
  extend ActiveSupport::Concern

  def self.jwt_revoked?(_payload, _user); end

  def self.revoke_jwt(_payload, _user); end
end
