class AddDescriptionToTicket < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :description, :text, comment: '赛票描述'
  end
end
