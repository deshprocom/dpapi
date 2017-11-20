class AddFreightTypeToFreight < ActiveRecord::Migration[5.0]
  def change
    add_column :freights, :freight_type, :string, default: '', comment: '类型'
  end
end
