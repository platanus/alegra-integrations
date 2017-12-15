class AddAlegraIdInProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :alegra_id, :integer
  end
end
