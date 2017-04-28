class CreateNewPlayer < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.string :player_id, limit: 32, comment: '牌手的uuid'
      t.string :name, limit: 255, default: '', comment: '牌手的姓名'
      t.string :avatar, limit: 100, comment: '牌手头像'
      t.string :gender, default: 0, comment: "牌手的性别, 0表示男， 1表示女"
      t.string :country, default: '', comment: '牌手的国籍'
      t.integer :dpi_total_earning, comment: '获取的总奖金(我们的赛事)'
      t.integer :gpi_total_earning, comment: '获取的总奖金(来源外部)'
      t.integer :dpi_total_score, comment: '获取的总积分(我们的赛事)'
      t.integer :gpi_total_score, comment: '获取的总积分(来源外部)'
      t.string :memo, default: '', comment: '备忘'
      t.timestamps
    end
  end
end
