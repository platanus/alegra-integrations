class SyncBankEntriesJob < ApplicationJob
  queue_as :crawlers

  def perform
    Product.all.each { |product| sync_product(product) }
  end

  private

  def sync_product(product)
    SyncEntriesUsingBankCrawler.for(
      product: product,
      payload: payload
    )
  end

  def payload
    {
      user_rut: ENV['BANCO_DE_CHILE_USER_RUT'],
      company_rut: ENV['BANCO_DE_CHILE_COMPANY_RUT'],
      password: ENV['BANCO_DE_CHILE_PASSWORD']
    }
  end
end
