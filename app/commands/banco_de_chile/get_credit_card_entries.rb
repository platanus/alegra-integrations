module BancoDeChile
  class GetCreditCardEntries < PowerTypes::Command.new(:payload)
    attr_reader :pincers

    def perform
      @pincers = BancoDeChile::Login.for(
        user_rut: @payload[:user_rut],
        company_rut: @payload[:company_rut],
        password: @payload[:password]
      )

      return get_entries
    ensure
      pincers.close
    end

    private

    def get_entries
      pincers.goto frame: pincers.search('[name="menu"]')

      CrawlerUtils.click_on_link_with_text(pincers, 'td', "Tarjeta Visa");
      CrawlerUtils.click_on_link_with_text(pincers, 'td', "En línea");

      pincers.goto frame: :top
      pincers.goto frame: pincers.search('[name="CONTENT"]')

      pincers.search('img[src="images/btn_consul.gif"]').click

      trs = pincers.search("table:nth-child(3) tr[align='left']")

      transaction_rows_to_bank_entries(trs)
    end

    def transaction_rows_to_bank_entries(trs)
      trs.map do |tr|
        next if !usd_row?(tr)

        tds = tr.search("td")

        date = tds[0].text
        description = tds[2].text
        amount = tds[5].text

        next if unconfirmed_transaction?(amount)

        CrawlerParsingUtils.entry_from_usd_credit_card(date, description, amount)
      end.compact
    end

    def usd_row?(tr)
      tr.search("td").count == 7
    end

    def unconfirmed_transaction?(amount)
      !amount.index('*').nil?
    end
  end
end
