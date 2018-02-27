class DocumentObserver < PowerTypes::Observer
  after_create :send_document_to_alegra

  def send_document_to_alegra
    SendDocumentToAlegraJob.perform_later(document: object)
  end
end
