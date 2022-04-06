class RemovePurchaserIdFrom < ActiveRecord::Migration[7.0]
  def change
    remove_column :addresses, :purchaser_id, :integer
  end
end
