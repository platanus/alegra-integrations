class Document < ApplicationRecord
  extend Enumerize
  DOCUMENT_TYPES = [:sale, :buy]
  enumerize :document_type, in: DOCUMENT_TYPES, default: nil, scope: true
end

# == Schema Information
#
# Table name: documents
#
#  id            :integer          not null, primary key
#  document_type :string
#  bsale_id      :integer
#  alegra_id     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
