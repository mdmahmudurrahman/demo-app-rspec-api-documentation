module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :authenticate_user!, only: [:create]

      # POST /api/v1/login
      def create
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password]) # Add `has_secure_password` for this to work
          user.regenerate_auth_token # Ensure a new token is issued
          render json: { auth_token: user.auth_token }, status: :ok
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end

      def destroy
        current_user&.update(auth_token: nil)
        head :no_content
      end
    end
  end
end
