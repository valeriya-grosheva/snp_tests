# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApiController
      def create
        user = User.find_by(username: params[:username]).try(:authenticate, params[:password])

        if user
          log_in(user)
          render json: user, serializer: UserSerializer
        else
          render json: { error: 'username or password is invalid' }, status: :bad_request
        end
      end

      def logout
        @current_user = nil
        session.destroy
        render json: { success: true }
      end

      private

      def user_params
        {
          username: params[:username],
          is_admin: params[:is_admin],
          password: params[:password],
          password_confirmation: params[:password_confirmation],
        }
      end
    end
  end
end
