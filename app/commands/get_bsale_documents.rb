class GetBsaleDocuments < PowerTypes::Command.new
  def perform
    get_sale_documents
    get_buy_documents
  end

  private

  def get_sale_documents
    documents = BsaleClient.new.get_sale_documents
    documents.each do |document|
      new_doc = Document.find_or_create_by(bsale_id: document.symbolize_keys[:id])
      if new_doc.bsale_info.nil?
        new_doc.update_columns(bsale_info: document, document_type: "sale")
      end
    end
  end

  def get_buy_documents
    documents = BsaleClient.new.get_buy_documents
    documents.each do |document|
      new_doc = Document.find_or_create_by(bsale_id: document.symbolize_keys[:id])
      if new_doc.bsale_info.nil?
        new_doc.update_columns(bsale_info: document, document_type: "buy")
      end
    end
  end
end
