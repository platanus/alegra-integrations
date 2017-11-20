require 'rails_helper'

describe SyncEntriesUsingBankCrawler do
  def perform(*_args)
    described_class.for(*_args)
  end

  let(:product) { create(:product, crawler_command_name: "BancoDeChile::GetCuentaCorrienteEntries") }

  let(:payload) {
    {
      user_rut: "123",
      company_rut: "1234",
      password: "4321",
      account_number: "1234"
    }
  }

  let(:bank_entries) {
    [
      BankEntry.new(Date.new(2017, 3, 3), "pago en línea", 25000, :deposit),
      BankEntry.new(Date.new(2017, 3, 4), "pago en línea 2", 25000, :deposit),
      BankEntry.new(Date.new(2017, 3, 5), "pago en línea 3", 25000, :deposit),
      BankEntry.new(Date.new(2017, 3, 5), "pago en línea 4", 25000, :expense)
    ]
  }

  before do
    create(:entry, product: product, signature: 12)
    create(:entry, product: product, signature: 14)
    create(:entry, product: create(:product), signature: 10)
  end

  before do
    allow(bank_entries[0]).to receive(:signature).and_return(12)
    allow(bank_entries[1]).to receive(:signature).and_return(10)
    allow(bank_entries[2]).to receive(:signature).and_return(13)
    allow(bank_entries[3]).to receive(:signature).and_return(20)
    allow(BancoDeChile::GetCuentaCorrienteEntries).to receive(:for).and_return(bank_entries)
  end

  context "#perform" do
    it "create only new entries" do
      perform(product: product, get_bank_crawler_command: BancoDeChile::GetCuentaCorrienteEntries, payload: payload)

      expect(Entry.count).to eq(6)
      expect(Entry.where(signature: 12).count).to eq(1)
      expect(Entry.where(signature: 13).count).to eq(1)
      expect(Entry.where(signature: 10).count).to eq(2)

      entry = Entry.where(signature: 13).first
      expect(entry.description).to eq(bank_entries[2].description)
    end

    it "create entries with correct data" do
      perform(product: product, get_bank_crawler_command: BancoDeChile::GetCuentaCorrienteEntries, payload: payload)

      bank_entry = bank_entries[2]
      bank_entry_expense = bank_entries[3]
      entry = Entry.where(signature: 13).first
      entry_expense = Entry.where(signature: 20).first

      expect(entry.description).to eq(bank_entry.description)
      expect(entry.amount).to eq(bank_entry.amount)
      expect(entry.date).to eq(bank_entry.date)
      expect(entry.product.name).to eq(product.name)
      expect(entry_expense.amount).to eq(bank_entry_expense.amount * -1)
    end
  end
end
