class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.belongs_to :book, null: false, foreign_key: true
      t.belongs_to :purchaser, null: false, foreign_key: true
      t.string :quantity

      t.timestamps
    end
  end
end
