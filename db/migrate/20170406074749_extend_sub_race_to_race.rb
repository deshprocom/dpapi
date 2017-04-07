class ExtendSubRaceToRace < ActiveRecord::Migration[5.0]
  def change
    add_column :races, :parent_id, :integer,
               default: 0,
               comment: '主赛的parent_id默认为0， 边赛的parent_id为主赛的id'

    add_column :races, :roy, :boolean,
               default: false,
               comment: '是否有roy'

    add_column :races, :blind, :string,
                  default: '',
                  comment: '赛事的盲注'

    add_column :races, :participants, :integer,
               comment: '赛事的参与人数'

    add_column :race_descs, :schedule, :text,
               comment: '赛事日程信息'
  end
end
