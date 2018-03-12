class AddRutToDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :documents, :rut, :string
  end
end
