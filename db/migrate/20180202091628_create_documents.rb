class CreateDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :documents do |t|
      t.string :document_type
      t.integer :bsale_id
      t.integer :alegra_id

      t.timestamps
    end
  end
end
