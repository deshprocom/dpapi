module AcFactory
  class AcUs050 < AcBase
    def ac_us050_01
      order = generate_order
      order.update(permit_order_params)
    end

    def permit_order_params
      params.permit(:status)
    end
  end
end