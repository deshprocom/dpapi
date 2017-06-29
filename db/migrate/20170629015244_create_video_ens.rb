class CreateVideoEns < ActiveRecord::Migration[5.0]
  def change
    create_table :video_ens do |t|
      t.references :video
      t.string :name
      t.text :description, comment: '视频英文描述'
      t.timestamps
    end
  end
end
