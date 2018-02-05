class Document < ApplicationRecord
end

# == Schema Information
#
# Table name: documents
#
#  id            :integer          not null, primary key
#  document_type :integer
#  bsale_id      :integer
#  alegra_id     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
