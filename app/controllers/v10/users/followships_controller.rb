module V10
  module Users
    class FollowshipsController < ApplicationController
      include UserAccessible
      before_action :login_required, :user_self_required

      def show
        followers = @current_user.followers.includes(:follower, follower: [:counter])
        followings = @current_user.followings.includes(:following, following: [:counter])
        render 'show', locals: { api_result: ApiResult.success_result, followers: followers, followings: followings }
      end

      def create
        followed_user = User.by_uuid(params[:target_id])
        Followship.create(follower: @current_user, following: followed_user)
        render_api_success
      end

      def destroy
        unfollowed_user = User.by_uuid(params[:target_id])
        followship = Followship.find_by!(follower: @current_user, following: unfollowed_user)
        followship.destroy!
        render_api_success
      end
    end
  end
end
