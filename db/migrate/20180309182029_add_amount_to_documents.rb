class AddAmountToDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :documents, :amount, :decimal, precision: 10, scale: 2
  end
end
