class Entry < ApplicationRecord
end

# == Schema Information
#
# Table name: entries
#
#  id          :integer          not null, primary key
#  product     :string
#  date        :date
#  description :text
#  amount      :decimal(10, 2)
#  signature   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
