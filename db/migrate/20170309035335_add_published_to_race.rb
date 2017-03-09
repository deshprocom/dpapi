class AddPublishedToRace < ActiveRecord::Migration[5.0]
  def change
    add_column :races, :published, :boolean,
              default: false,
              comment: '该赛事是否已发布'
  end
end
