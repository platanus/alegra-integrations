class SendDocumentToAlegra < PowerTypes::Command.new(:document)
  def perform
    send 
    mark_as_synced
  end

  private

  def send
    alegra_api_service = AlegraApiService.new
    alegra_api_service.post('payments/',alegra_payload)
  end
  def alegra_payload
    
    {
      document_type: @document.href,
      bsale_id: @document.id,
      alegra_id: alegraID
    }
  end

end
