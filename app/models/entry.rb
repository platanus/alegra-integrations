class Entry < ApplicationRecord
  extend Enumerize

  belongs_to :product

  ALEGRA_STATUS = [:new, :synced, :discared]
  enumerize :alegra_status, in: ALEGRA_STATUS, default: ALEGRA_STATUS.first
end

# == Schema Information
#
# Table name: entries
#
#  id            :integer          not null, primary key
#  product       :string
#  date          :date
#  description   :text
#  amount        :decimal(10, 2)
#  signature     :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  alegra_status :string
#  product_id    :integer
#
# Indexes
#
#  index_entries_on_product_id  (product_id)
#
# Foreign Keys
#
#  fk_rails_03dab91dad  (product_id => products.id)
#
