class Document < ApplicationRecord
  extend Enumerize
  DOCUMENT_TYPES = [:sale, :buy]
  ALEGRA_STATUS = [:new, :synced, :error]
  enumerize :alegra_status, in: ALEGRA_STATUS, default: ALEGRA_STATUS.first
  enumerize :document_type, in: DOCUMENT_TYPES, default: nil, scope: true
  serialize :bsale_info, JSON

  def url_contact_bsale
    bsale_info["client"]["href"] if bsale_info && bsale_info["client"]
  end
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
#  bsale_info    :text
#  alegra_status :string
#
