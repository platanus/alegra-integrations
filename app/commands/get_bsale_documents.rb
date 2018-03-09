class GetBsaleDocuments < PowerTypes::Command.new
  def perform
    get_sale_documents
    get_buy_documents
  end

  private

  def get_sale_documents
    bsale_documents = BsaleClient.new.get_sale_documents

    bsale_documents.each do |bsale_document|
      Document.find_or_create_by(bsale_id: bsale_document.symbolize_keys[:id]) do |document|
        document.bsale_info = bsale_document
        document.document_type = :sale
        document.legal_id = bsale_document[:number]
        document.rut = get_rut(bsale_document)
        document.date = Time.at(bsale_document[:emissionDate]).to_date
        document.amount = bsale_document[:totalAmount]
      end
    end
  end

  def get_buy_documents
    bsale_documents = BsaleClient.new.get_buy_documents

    bsale_documents.each do |bsale_document|
      Document.find_or_create_by(bsale_id: bsale_document.symbolize_keys[:id]) do |document|
        document.bsale_info = bsale_document
        document.document_type = :buy
        document.legal_id = bsale_document[:number]
        document.rut = get_rut(bsale_document)
        document.date = Time.at(bsale_document[:emissionDate]).to_date
        document.amount = bsale_document[:totalAmount]
      end
    end
  end

  def get_rut(bsale_document)
    return bsale_document[:clientCode] if bsale_document[:clientCode]
    BsaleClient.new.get_bsale_object(bsale_document[:client][:href])[:code]
  end
end
