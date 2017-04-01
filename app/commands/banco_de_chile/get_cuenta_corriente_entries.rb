module BancoDeChile
  class GetCuentaCorrienteEntries < PowerTypes::Command.new(:payload)
    attr_reader :pincers

    def perform
      @pincers = BancoDeChile::Login.for(
        user_rut: @payload[:user_rut],
        company_rut: @payload[:company_rut],
        password: @payload[:password]
      )

      get_cuenta_corriente_entries
    ensure
      pincers.close
    end

    private

    def get_cuenta_corriente_entries
      pincers.goto frame: pincers.search('[name="menu"]')

      CrawlerUtils.click_on_link_with_text(pincers, 'td', "Cuentas Corrientes");
      CrawlerUtils.click_on_link_with_text(pincers, 'td', "Saldos y Movimientos");

      pincers.goto frame: :top
      pincers.goto frame: pincers.search('[name="CONTENT"]')

      pincers.search("input#btnSeleccionarCuenta").click

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
        match[2].to_i,
        match[4] == "A" ? :deposit : :expense
      )
    end
  end
end
