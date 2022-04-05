class Move < ActiveRecord::Migration[7.0]
  def change
    add_column :addresses, :order_id, :int
  end
end
