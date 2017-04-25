class RemoveImageThumbFromInfo < ActiveRecord::Migration[5.0]
  def change
    remove_column :infos, :image_thumb, :string
  end
end
