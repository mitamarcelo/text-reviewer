class ApplicationController < ActionController::API
  include Authentication
  include ErrorHandler
end
