class DocumentObserver < PowerTypes::Observer
  after_create :send_document_to_alegra

  def send_document_to_alegra
    SendDocumentToAlegra.for(document: object)
  end
end
