ActiveAdmin.register Entry do
  # permit_params :list, :of, :attributes, :on, :model
  batch_action :destroy, false
  config.sort_order = 'date_desc'

  batch_action :send_to_alegra do |ids|
    batch_action_collection.find(ids).each do |entry|
      SendEntryToAlegra.for(entry: entry)
    end
    redirect_to collection_path, alert: "Las transacciones fueron Alegradas"
  end

  batch_action :discard do |ids|
    batch_action_collection.find(ids).each do |entry|
      entry.update(alegra_status: :discared)
    end
    redirect_to collection_path, alert: "Las transacciones fueron Descartadas"
  end

  index do
    selectable_column
    id_column
    column :product do |entry|
      status_tag entry.product, :ok
    end
    column :date do |entry|
      entry.date&.strftime("%d/%m/%Y")
    end
    column :description
    column :ingreso do |entry|
      number_with_delimiter(entry.amount.to_i, delimiter: ".") if entry.amount&.positive?
    end
    column :egreso do |entry|
      number_with_delimiter(entry.amount.to_i, delimiter: ".") if entry.amount&.negative?
    end
    tag_column :alegra_status
    column :signature
    actions
  end
end
