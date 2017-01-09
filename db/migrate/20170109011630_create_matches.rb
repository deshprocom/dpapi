class CreateMatches < ActiveRecord::Migration[5.0]
  def change
    create_table :matches do |t|
      t.references :countries, foreign_key: true
      t.string :name, comment: '比赛的名称'
      t.datetime :start_time, comment: '比赛的时间'
      t.datetime :end_time, comment: '结束的时间'
      t.string :venue, comment: '比赛的场地'
      t.timestamps
    end
  end
end
