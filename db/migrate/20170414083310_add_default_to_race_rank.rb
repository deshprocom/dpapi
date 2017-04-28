class AddDefaultToRaceRank < ActiveRecord::Migration[5.0]
  def change
    change_column :race_ranks, :earning, :integer,
                  default: 0,
                  comment: '收入奖金'

    change_column :race_ranks, :score, :integer,
                  default: 0,
                  comment: '得分'
  end
end
