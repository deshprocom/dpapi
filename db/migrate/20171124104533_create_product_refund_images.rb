class CreateProductRefundImages < ActiveRecord::Migration[5.0]
  def change
    create_table :product_refund_images do |t|
      t.references :product_refund
      t.string :image, comment: '退款上传图片'
      t.timestamps
    end
  end
end
