class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :crawler_command_name

      t.timestamps
    end
  end
end
