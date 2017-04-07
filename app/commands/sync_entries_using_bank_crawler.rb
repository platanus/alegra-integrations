class SyncEntriesUsingBankCrawler < PowerTypes::Command.new(:product, :get_bank_crawler_command, :payload)
  def perform
    bank_entries = @get_bank_crawler_command.for(payload: @payload)
    SignEntries.for(bank_entries: bank_entries)
    create_new_entries(bank_entries)
  end

  private

  def create_new_entries(bank_entries)
    bank_entries.each do |bank_entry|
      entry = Entry.find_or_create_by(product: @product, signature: bank_entry.signature)
      sign = bank_entry.type == :deposit ? 1 : -1

      entry.update_attributes(
        {
          description: bank_entry.description,
          amount: bank_entry.amount * sign,
          date: bank_entry.date
        }
      )
    end
  end
end
