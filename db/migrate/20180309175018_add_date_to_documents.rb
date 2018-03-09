class AddDateToDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :documents, :date, :date
  end
end
