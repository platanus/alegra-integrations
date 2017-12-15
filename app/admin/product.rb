ActiveAdmin.register Product do
  config.filters = false
  actions :all, except: [:destroy, :show]

  permit_params :alegra_id, :crawler_command_name, :name

  index do
    id_column
    column :name
    column :crawler_command_name
    column :alegra_id
    actions
  end

  form do |f|
    f.inputs "Product Details" do
      f.input :name
      f.input :crawler_command_name
      f.input :alegra_id
    end
    f.actions
  end
end
