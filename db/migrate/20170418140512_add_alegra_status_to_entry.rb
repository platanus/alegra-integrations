class AddAlegraStatusToEntry < ActiveRecord::Migration[5.0]
  def change
    add_column :entries, :alegra_status, :string
  end
end
