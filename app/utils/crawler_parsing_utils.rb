module CrawlerParsingUtils
  extend self

  def entry_from_usd_credit_card(date, description, amount)
    date_parts = date.split('/')
    cleaned_amount = clean_amount(amount)

    BankEntry.new(
      complete_date_with_year(date_parts[1].to_i, date_parts[0].to_i),
      description,
      cleaned_amount.abs,
      cleaned_amount > 0 ? :expense : :deposit
    )
  end

  private

  def clean_amount(amount)
    amount.sub(',', '.').gsub(/[^\d,\.,-]/, '').to_f
  end

  def complete_date_with_year(month, day)
    year = month > 10 && Date.today.month < 3 ? Date.today.year - 1 : Date.today.year
    Date.new(year, month, day)
  end
end
