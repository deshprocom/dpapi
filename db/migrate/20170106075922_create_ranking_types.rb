class CreateRankingTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :ranking_types do |t|
      t.string :name, limit: 100, comment: '排名的类型'
      t.timestamps
    end
  end
end
