module V10
  module Orders
    class PayController < ApplicationController
      include UserAccessible
      before_action :login_required, :user_self_required

      def create
        order_id = params[:order_id]
      end
    end
  end
end
