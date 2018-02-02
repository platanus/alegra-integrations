class AddBsaleInfoToDocument < ActiveRecord::Migration[5.0]
  def change
    add_column :documents, :bsale_info, :text
  end
end
