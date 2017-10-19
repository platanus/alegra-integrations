module BancoDeChile
  class GetCuentaCorrienteUsdEntries < PowerTypes::Command.new(:payload)
    attr_reader :pincers

    def perform
      @pincers = BancoDeChile::Login.for(
        user_rut: @payload[:user_rut],
        company_rut: @payload[:company_rut],
        password: @payload[:password]
      )

      navigate_to_entries
      entries = get_entries
      filter_bad_entries entries
    ensure
      pincers.close
    end

    private

    def navigate_to_entries
      pincers.goto frame: pincers.search('[name="menu"]')

      CrawlerUtils.click_on_link_with_text(pincers, 'td', 'Cuentas Corrientes')
      CrawlerUtils.click_on_link_with_text(pincers, 'td', 'Saldos y Movimientos')

      pincers.goto frame: :top
      pincers.goto frame: pincers.search('[name="CONTENT"]')

      pincers.search('select[name="moneda"]').set by_value: 'CEX'
      pincers.search("input#btnSeleccionarCuenta").click
    end

    def get_entries
      txt = pincers.search("div#expoDato_child a:contains('txt')").download

      result = []
      txt.content.each_line { |line| result << parse_cuenta_corriente_line(line) }

      result
    end

    def parse_cuenta_corriente_line(line)
      match = /.{11}(.{8}).{18}(.+)\+[\d]{3}(.{45})(.{1})/.match(line)

      BankEntry.new(
        Date.strptime(match[1],"%Y%m%d"),
        match[3].strip.encode("UTF-8", invalid: :replace, undef: :replace, replace: ''),
        match[2].to_f,
        match[4] == "A" ? :deposit : :expense
      )
    end

    def filter_bad_entries(entries)
      banned_descriptions = ['RETENCIONES + 1 DIA', 'RETENCIONES 1 DIA', 'SALDO CONTABLE']

      entries.select { |entry| !banned_descriptions.include?(entry.description)  }
    end
  end
end
