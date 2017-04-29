class CreatePhoto < ActiveRecord::Migration[5.0]
  def change
    create_table :photos do |t|
      t.references :user, polymorphic: true, index: true
      t.string :image
      t.timestamps
    end
  end
end
