module BancoDeChile
  class Login < PowerTypes::Command.new(:user_rut, :company_rut, :password)
    require 'pincers'
    attr_reader :pincers

    def perform
      @pincers = Pincers.for_webdriver :phantomjs
      login
      pincers
    end

    private

    def login
      pincers.goto 'https://ww3.bancochile.cl/wps/wcm/connect/bch-empresas/bancodechile/empresas/'

      CrawlerUtils.click_on_link_with_text(@pincers, 'div.login', "Banconexión Empresas")

      fill_rut_inputs('rutemp1', 'dvemp1', @company_rut)
      fill_rut_inputs('rut1', 'verificador1', @user_rut)
      pincers.search('input#pin1').set(@password)

      CrawlerUtils.click_on_link_with_text(pincers, 'div#contenidoslogin', "Ingresar")
    end

    def fill_rut_inputs(rut_input_id, dv_input_id, rut)
      rut_base = rut.split('-')[0]
      rut_dv = rut.split('-')[1]

      pincers.search("input##{rut_input_id}").set(rut_base)
      pincers.search("input##{dv_input_id}").set(rut_dv)
    end
  end
end

