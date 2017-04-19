ActiveAdmin.register Entry do
  # permit_params :list, :of, :attributes, :on, :model
  config.sort_order = 'date_desc'

  index do
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
