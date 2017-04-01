class CreateEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :entries do |t|
      t.string :product
      t.date :date
      t.text :description
      t.decimal :amount, precision: 10, scale: 2
      t.string :signature

      t.timestamps
    end
  end
end
