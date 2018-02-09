class GetBsaleSaleDocuments < PowerTypes::Command.new
  def perform
    documents = BsaleClient.new.get_documents
    documents.each do |document|
      new_doc = Document.find_or_create_by(bsale_id: document.symbolize_keys[:id])
      if new_doc.bsale_info.nil?
        new_doc.update_columns(bsale_info: document, document_type: "sale")
      end
    end
  end
end
