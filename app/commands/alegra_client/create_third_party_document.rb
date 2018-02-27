class AlegraClient::CreateThirdPartyDocument < PowerTypes::Command.new(:document_hash)
  require 'pincers'

  def perform
    crawler_to_alegra
  end

  private

  def crawler_to_alegra
    id = ""
    Pincers.for_webdriver :phantomjs do |pincers|
      log_in(pincers)
      set_client_info(pincers)
      set_dates(pincers)
      set_invoiceitems_info(pincers)
      id = save(pincers)
    end
    { "id" => id }
  end

  def log_in(pincers)
    pincers.goto "https://app2.alegra.com/"
    pincers.search("input[name=email]").set(ENV.fetch("ALEGRA_USER"))
    pincers.search("input[name=password]").set(ENV.fetch("ALEGRA_PASSWORD"))
    pincers.search("form").submit
  end

  def set_client_info(pincers)
    pincers.goto "https://app2.alegra.com/bill/add"
    pincers.search("input[name=idClient]").set(@document_hash[:id_client])
    pincers.search("textarea[name=observations]").set(@document_hash[:observations])
    pincers.search("input[name=billNumber]").set(@document_hash[:bill_number])
  end

  def set_dates(pincers)
    if !@document_hash[:bill_date].nil?
      pincers.search("#billDateDatefield-inputEl").set(@document_hash[:bill_date])
    end
    if !@document_hash[:bill_due_date].nil?
      pincers.search("#billDueDateDatefield-inputEl").set(@document_hash[:bill_due_date])
    end
  end

  def set_invoiceitems_info(pincers)
    pincers.search("input[name=idCategory]").set(@document_hash[:id_category])
    pincers.search(tag: 'li', content: @document_hash[:id_category]).click
    pincers.search("input[name=price]").set(@document_hash[:price])
  end

  def save(pincers)
    pincers.search("#button-1082").click
    pincers.search("#viewInvoiceInfo").wait(:present)
    pincers.uri.path.split('/').last
  end
end
