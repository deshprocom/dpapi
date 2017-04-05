class ExtendRace < ActiveRecord::Migration[5.0]
  def change
    add_column :races, :ticket_sellable, :boolean,
               default: true,
               comment: '是否有售票功能'

    add_column :races, :describable, :boolean,
               default: true,
               comment: '是否有详情内容'

    change_column :races, :prize, :string,
                  default: '',
                  comment: '赛事的奖池'
  end
end
