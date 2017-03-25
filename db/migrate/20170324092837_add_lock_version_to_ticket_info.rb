class AddLockVersionToTicketInfo < ActiveRecord::Migration[5.0]
  def change
    add_column :ticket_infos, :lock_version, :integer
  end
end
