class ExtendTicketInfoToRace < ActiveRecord::Migration[5.0]
  def change
    add_column :races, :ticket_status, :string,
               limit: 30,
               default: 'unsold',
               comment: '售票的状态 unsold-未售票, selling-售票中, end-售票结束, sold_out-票已售完'
    add_column :races, :ticket_price, :integer,
               default: 0,
               comment: '票的价格'
  end
end
