class AddCustomerIdToPurchaser < ActiveRecord::Migration[7.0]
  def change
    add_column :purchasers, :customer_id, :integer
  end
end
