class CreateDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :documents do |t|
      t.integer :document_type
      t.integer :bsale_id,   unique: true
      t.integer :alegra_id,  unique: true

      t.timestamps
    end
  end
end
