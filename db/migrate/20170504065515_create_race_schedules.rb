class CreateRaceSchedules < ActiveRecord::Migration[5.0]
  def change
    create_table :race_schedules do |t|
      t.references :race
      t.string :schedule, limit: 25, comment: '日程表'
      t.datetime :begin_time
      t.timestamps
    end
  end
end
