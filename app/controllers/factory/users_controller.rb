module Factory
  class UsersController < ApplicationController
    def create
      user = FactoryGirl.create(:user, user_params.as_json)
      template = 'v10/account/users/base'
      render template, locals: { api_result: ApiResult.success_result, user: user }
    end

    def user_params
      params.permit(:user_uuid,
                    :user_name,
                    :nick_name,
                    :gender,
                    :password_salt,
                    :password,
                    :mobile,
                    :email,
                    :reg_date,
                    :last_visit)
    end
  end
end
