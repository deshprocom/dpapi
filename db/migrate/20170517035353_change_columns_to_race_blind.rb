class ChangeColumnsToRaceBlind < ActiveRecord::Migration[5.0]
  def change
    change_column :race_blinds, :small_blind, :string,
                  default: '0',
                  comment: '最小盲注'
    change_column :race_blinds, :big_blind, :string,
                  default: '0',
                  comment: '最大盲注'
    change_column :race_blinds, :ante, :string,
                  default: '0',
                  comment: '前注'
    change_column :race_blinds, :race_time, :string,
                  default: '0',
                  comment: '赛事时间'
  end
end
