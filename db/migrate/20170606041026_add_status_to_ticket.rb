class AddStatusToTicket < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :status, :string,
               limit: 30,
               default: 'unsold',
               comment: '售票的状态 unsold-未售票, selling-售票中, end-售票结束, sold_out-票已售完'
    remove_column :tickets, :ticket_sellable
  end
end
