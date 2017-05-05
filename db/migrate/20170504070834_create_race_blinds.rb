class CreateRaceBlinds < ActiveRecord::Migration[5.0]
  def change
    create_table :race_blinds do |t|
      t.references :race
      t.integer :level, default: 0, comment: '级别'
      t.integer :small_blind, default: 0, comment: '最小盲注'
      t.integer :big_blind, default: 0, comment: '最大盲注'
      t.integer :ante, default: 0, comment: '前注'
      t.integer :race_time, default: 0, comment: '赛事时间'
      t.integer :type, default: 0, comment: '0表示有盲注，前注这些， 1表示有文字输入'
      t.string :content, default: '', comment: '文字输入类型对应的内容'
      t.timestamps
    end
  end
end
