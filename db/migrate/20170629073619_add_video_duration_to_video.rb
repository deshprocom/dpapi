class AddVideoDurationToVideo < ActiveRecord::Migration[5.0]
  def change
    add_column :videos, :video_duration, :string, comment: '视频时长'
  end
end
