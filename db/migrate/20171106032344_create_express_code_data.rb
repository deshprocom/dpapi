class CreateExpressCodeData < ActiveRecord::Migration[5.0]
  # 判断province,city,area表是否有数据，没有的话就初始化数据
  require './db/express_codes'
  def up
    add_column :express_codes, :published, :boolean, default: false, comment: '是否发布'
    return if ExpressCode.count > 0
    EXPRESS_CODE.collect do |item|
      ExpressCode.unscoped.create(id: item[:id], name: item[:name], express_code: item[:express_code], region: item[:region])
    end
  end

  def down
    ExpressCode.destroy_all
  end
end
