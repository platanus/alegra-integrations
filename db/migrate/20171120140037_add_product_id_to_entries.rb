class AddProductIdToEntries < ActiveRecord::Migration[5.0]
  def change
    add_reference :entries, :product, foreign_key: true
  end
end
