class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  
  before_action :authenticate_user!

  private

  # Authenticate user by auth token
  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    @current_user = User.find_by(auth_token: token)
    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
  end

  # Provide access to the authenticated user
  def current_user
    @current_user
  end
end
