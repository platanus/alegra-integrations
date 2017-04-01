require 'rails_helper'

describe SignEntries do
  def perform(*_args)
    described_class.for(*_args)
  end

  let(:entries) { [BankEntry.new(Date.new(2017, 3, 3), "pago en línea", 25000, :deposit)] }

  context "with a single entry" do
    it "calculates the corresponding signature" do
      perform(bank_entries: entries)
      expect(entries[0].signature).to eq("15dded83179e9214e9bade1af819f3d3348bc984")
    end
  end

  context "with entries with same data" do
    before do
      entries << BankEntry.new(Date.new(2017, 3, 3), "pago en línea", 25000, :deposit)
    end

    it "calculates different signature" do
      perform(bank_entries: entries)
      expect(entries[0].signature).to eq("15dded83179e9214e9bade1af819f3d3348bc984")
      expect(entries[1].signature).not_to eq("15dded83179e9214e9bade1af819f3d3348bc984")
    end
  end
end
