# lib/tasks/frogo/run.rake
namespace :crawlers do
  desc 'Run frogo watcher'
  task run: :environment do
    payload = {
      user_rut: ENV['BANCO_DE_CHILE_USER_RUT'],
      company_rut: ENV['BANCO_DE_CHILE_COMPANY_RUT'],
      password: ENV['BANCO_DE_CHILE_PASSWORD']
    }

    SyncEntriesUsingBankCrawler.for(product: 'cuenta corriente',
                                    get_bank_crawler_command: BancoDeChile::GetCuentaCorrienteEntries,
                                    payload: payload)
  end
end
