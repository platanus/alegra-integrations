ActiveAdmin.register Document do
  config.filters = false
  actions :index, :show

  permit_params :document_type

  index do
    id_column
    column :document_type
    column :bsale_id
    column :alegra_id
    column :created_at
    actions
  end
end
