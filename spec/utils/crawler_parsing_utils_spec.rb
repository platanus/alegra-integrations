require 'rails_helper'

describe CrawlerParsingUtils do
  context '#entry_from_usd_credit_card' do
    date_param ='09/01'
    description_param = 'UBER CL MAY05 SEHBC COMPRAS INT.VI'
    amount_param ='+ 29,15'

    let(:entry) do
      described_class.entry_from_usd_credit_card(date_param, description_param, amount_param)
    end

    before do
      Timecop.freeze(Time.local(2018, 1, 20))
    end

    it 'set the correct description' do
      expect(entry.description).to eq(description_param)
    end

    it 'set the correct decimal amount' do
      expect(entry.amount).to eq(29.15)
    end

    context 'when amount is positive' do
      before { amount_param = '+ 29,00' }

      it 'sets considere a expending' do
        expect(entry.amount).to eq(29)
        expect(entry.type).to eq(:expense)
      end
    end

    context 'when amount is negative' do
      before { amount_param = '- 29,00' }

      it 'sets considere a deposit' do
        expect(entry.amount).to eq(29)
        expect(entry.type).to eq(:deposit)
      end
    end

    context 'when transaction are within current year' do
      before { date_param = '09/01' }

      it 'set current year in date' do
        expect(entry.date).to eq(Date.new(2018, 1, 9))
      end
    end

    context 'when transaction arent within current year' do
      before do date_param = '09/12' end

      it 'set last year in date' do
        expect(entry.date).to eq(Date.new(2017, 12, 9))
      end
    end
  end
end
