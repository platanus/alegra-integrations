class SignEntries < PowerTypes::Command.new(:bank_entries)
  attr_reader :entry_occurrencies # { bank_entry, occurrencies }

  def perform
    @entry_occurrencies = get_entry_occurrencies
    sign_entries
  end

  private

  def get_entry_occurrencies
    entry_occurrencies_keys = {}

    @bank_entries.map do |entry|
      key = entry_key(entry)
      occurrency = entry_occurrencies_keys[key] || 0
      entry_occurrencies_keys[key] = occurrency + 1

      { bank_entry: entry, occurrencies: entry_occurrencies_keys[key] }
    end
  end

  def sign_entries
    @entry_occurrencies.each { |entry_occurrency| sign_entry(entry_occurrency) }
  end

  def sign_entry(entry_occurrency)
    entry = entry_occurrency[:bank_entry]
    occurrencies = entry_occurrency[:occurrencies]

    entry.signature = entry_signature(entry, occurrencies)
  end

  def entry_signature(entry, occurrencies)
    key = entry_key(entry)
    Digest::SHA1.hexdigest("#{key}|#{occurrencies}")
  end

  def entry_key(entry)
    "#{entry.date}|#{entry.description}|#{entry.amount}|#{entry.type}"
  end
end
