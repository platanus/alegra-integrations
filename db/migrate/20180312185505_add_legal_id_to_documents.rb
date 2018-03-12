class AddLegalIdToDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :documents, :legal_id, :string
  end
end
