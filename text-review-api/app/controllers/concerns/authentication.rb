module Authentication
  extend ActiveSupport::Concern

  def current_user
    @current_user
  end

  def authenticate_user!
    jwt_payload = process_authorization_token

    raise CustomError::Unauthorized, 'Access Token: User identifier missing' unless jwt_payload['jti']

    @current_user = User.find_by_jti(jwt_payload['jti'])
    raise CustomError::Unauthorized, 'Access Token: User identifier invalid' unless @current_user.present?
  end

  def invalidate_user!
    @current_user = nil
    jwt_payload = process_authorization_token
    user = User.find_by_jti(jwt_payload['jti'])
    return unless user

    user.update_column(:jti, SecureRandom.uuid)
  end

  private

  def user_params
    params.require(:session).permit(:email, :password)
  end

  def user_registration_params
    params.require(:registration).permit(:email, :password, :name)
  end

  def process_authorization_token
    token = request.headers['Authorization']
    raise CustomError::Unauthorized, 'Authorization not provided' unless token.present?

    jwt = token.split(' ').last
    JWT.decode(jwt, Rails.application.credentials.devise_jwt_secret_key!).first
  end

  def set_authorization_header(user)
    response.set_header('Authorization', "Bearer #{generate_access_token(user)}")
  end

  def generate_access_token(user)
    JWT.encode(user.jwt_payload, Rails.application.credentials.devise_jwt_secret_key!)
  end
end
