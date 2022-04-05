class ChangeDataTypeToAddrType < ActiveRecord::Migration[7.0]
  def change
    remove_column :addresses, :type
    add_column :addresses, :addr_type, :string
  end
end
