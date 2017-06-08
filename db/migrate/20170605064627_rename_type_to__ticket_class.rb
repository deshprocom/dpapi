class RenameTypeToTicketClass < ActiveRecord::Migration[5.0]
  def change
    remove_column :tickets, :type
    add_column :tickets, :ticket_class, :string,
               default: 'race',
               comment: '类型:single_ticket -> 仅赛票, package_ticket -> 套票'
  end
end
