class CreateStocks < ActiveRecord::Migration[7.2]
  def change
    create_table :stocks do |t|
      t.string :name
      t.string :symbol
      t.text :description
      t.decimal :price

      t.timestamps
    end
  end
end
