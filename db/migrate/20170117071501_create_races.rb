class CreateRaces < ActiveRecord::Migration[5.0]
  def change
    create_table :races do |t|
      t.string :name, limit: 256, comment: '赛事的名称'
      t.string :logo, limit: 256, comment: '赛事的logo'
      t.integer :prize, default:0, null: false, comment: '赛事的奖池'
      t.string :location, limit:256, comment: '赛事比赛地点'
      t.date :start_time, comment: '赛事开始时间'
      t.date :end_time, comment: '赛事结束的时间'
      t.integer :status, default:0, null: false, comment: '赛事的状态 0-未开始  1-进行中  2-已结束  3-已关闭'
      t.timestamps
    end
  end
end
