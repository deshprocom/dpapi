class AddPublishedToExpressCodes < ActiveRecord::Migration[5.0]
  def change
    unless column_exists?(:express_codes, :published)
      add_column :express_codes, :published, :boolean, default: false, comment: '是否发布'
    end
  end
end
