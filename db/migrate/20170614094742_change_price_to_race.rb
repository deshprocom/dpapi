class ChangePriceToRace < ActiveRecord::Migration[5.0]
  def change
    change_column :races, :ticket_price, :string,
                  default: '',
                  comment: '票的价格'
  end
end
