class ExchangeNameAndExpressCode < ActiveRecord::Migration[5.0]
  def up
    unless column_exists?(:express_codes, :published)
      add_column :express_codes, :published, :boolean, default: false, comment: '是否发布'
    end
    return unless ExpressCode.count > 0
    ExpressCode.all.each do |item|
      old_name = item.name
      old_express_code = item.express_code
      item.update(name: old_express_code, express_code: old_name)
    end
  end

  def down
    return unless ExpressCode.count > 0
    ExpressCode.all.each do |item|
      old_name = item.name
      old_express_code = item.express_code
      item.update(name: old_express_code, express_code: old_name)
    end
  end
end
