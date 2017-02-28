module AcFactory
  class AcUs047 < AcBase

    def ac_us047_01
      update_order_status
    end

    def update_order_status
      user = User.by_email(params[:user])
      order = user.orders.first
      order.update(status: params[:status])
    end
  end
end