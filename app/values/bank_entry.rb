class BankEntry
  attr_accessor :date, :description, :amount, :type, :signature

  def initialize(date, description, amount, type)
    @date = date
    @description = description
    @amount = amount
    @type = type
  end
end
