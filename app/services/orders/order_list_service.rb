module Services
  module Orders
    class OrderListService
      include Serviceable
      attr_accessor :user, :page_size, :next_id, :status

      def initialize(page_size, next_id, status, user)
        self.page_size = page_size.blank? ? '10' : page_size
        self.next_id = next_id.blank? ? '0' : next_id
        self.status = status.blank? ? 'all' : status
        self.user = user
      end

      def call
        orders = user.orders.where("order_number > #{next_id}")
                     .limit(page_size)
                     .order(order_number: :desc)
        orders = orders.where(status: status) if %w(unpaid paid unshipped completed canceled).include?(status)
        order_lists = orders.select { |order| order.snapshot.present? }
                            .map { |order| { order_info: order, race_info: order.snapshot } }
        data = { order_lists: order_lists }
        data[:next_id] = orders.first.order_number unless order_lists.blank?
        ApiResult.success_with_data(data)
      end
    end
  end
end
