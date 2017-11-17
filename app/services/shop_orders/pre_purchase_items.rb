module Services
  module ShopOrders
    class PrePurchaseItems
      attr_reader :order_items
      def initialize(variants, province = nil)
        @province = province
        @order_items = variants.to_a.map do |variant|
          ProductOrderItem.new(variant: Variant.find(variant[:id]),
                               number: variant[:number].to_i)
        end
      end

      def purchasable_check
        return '无效的商品参数' if order_items.blank?

        order_items.each do |item|
          return "该商品已下架：#{item.variant.product.title}" unless item.variant.product.published?

          return '购买数量不能小于等于0' if item.number <= 0

          return "商品:#{item.variant.product.title}库存不足：" if item.number > item.variant.stock
        end

        'ok'
      end

      def check_result
        @check_result ||= purchasable_check
      end

      def total_price
        total_product_price + shipping_price
      end

      def total_product_price
        @total_product_price ||= @order_items.inject(0) do |n, item|
          (item.variant.price * item.number) + n
        end
      end

      def freight_free?
        # 只要有一件商品包邮，所有商品包邮
        @freight_free ||= @order_items.any? { |item| item.variant.product.freight_free? }
      end

      def shipping_price
        return 0 if freight_free?

        @shipping_price ||= @order_items.map do |item|
          item.variant.product.freight_fee(@province)
        end.max
      end

      def save_to_order(order)
        @order_items.each do |item|
          save_order_item(item, order)
          stock_decrease(item)
        end
      end

      def save_order_item(item, order)
        item.product_order = order
        item.save
      end

      def stock_decrease(item)
        item.variant.stock_decrease(item.number)
      end
    end
  end
end
