class AddToAlegraStatusToDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :documents, :alegra_status, :string
  end
end
