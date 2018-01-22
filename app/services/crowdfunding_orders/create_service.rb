module Services
  module CrowdfundingOrders
    class CreateService
      include Serviceable
      include Constants::Error::Order

      def initialize(user, cf_player, number)
        @user = user
        @cf_player = cf_player
        @number = number
      end

      def call
        # 1 查看该用户是否有购买过该用户
        # 2 购买的分数是否超出限购的份数
        return ApiResult.error_result(LIMIT_PAY) if limit?
        order = CrowdfundingOrder.create(user: @user,
                                         crowdfunding_player: @cf_player,
                                         crowdfunding: @cf_player.crowdfunding,
                                         order_stock_number: @number,
                                         order_stock_money: @cf_player.stock_unit_price,
                                         total_money: @number * @cf_player.stock_unit_price)
        ApiResult.success_with_data(order: order)
      end

      def limit?
        (@number + past_buy_number) > @cf_player.limit_buy
      end

      def past_buy_number
        CrowdfundingOrder.where(paid: true)
                         .where(crowdfunding_player: @cf_player)
                         .where(user: @user)
                         .sum(&:order_stock_number)
      end
    end
  end
end
