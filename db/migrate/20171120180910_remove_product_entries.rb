class RemoveProductEntries < ActiveRecord::Migration[5.0]
  def change
    remove_column :entries, :product, :string
  end
end
