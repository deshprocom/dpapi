class CreateRaceHosts < ActiveRecord::Migration[5.0]
  def change
    create_table :race_hosts do |t|
      t.string :name, comment: '主办方名称'
      t.timestamps
    end
  end
end
