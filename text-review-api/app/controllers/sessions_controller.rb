class SessionsController < Devise::SessionsController
  respond_to :json

  # POST /sign_in
  def create
    @user = authenticate_credentials!(
      user_params[:email],
      user_params[:password]
    )
    set_authorization_header(@user)
    head :no_content
  end

  private

  def authenticate_credentials!(email, password)
    user = User.find_by_email(email)
    if user.nil? || !user.valid_password?(password)
      raise CustomError::CredentialInvalid,
            'Email or password invalid'
    end

    user
  end

  def session_params
    params.require(:session).permit(:email, :password)
  end

  def respond_to_on_destroy
    head :no_content
  end
end
