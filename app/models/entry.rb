class Entry < ApplicationRecord
  extend Enumerize

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
#
