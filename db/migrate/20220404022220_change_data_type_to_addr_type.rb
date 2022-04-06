class ChangeDataTypeToAddrType < ActiveRecord::Migration[7.0]
  def change
    remove_column :addresses, :type, :string
    add_column :addresses, :addr_type, :string
  end
end
