PurchaseOrder.all.each do |item|
  item.update(final_price: item.price)
end

CrowdfundingOrder.all.each do |item|
  item.update(final_price: item.total_money)
end

ProductOrder.all.each do |item|
  item.update(final_price: item.total_price)
end