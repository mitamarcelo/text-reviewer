class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:test_login]

  def logout
    invalidate_user!
    head :no_content
  end
end
