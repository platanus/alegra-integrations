class SendDocumentToAlegra < PowerTypes::Command.new(:document)
  def perform
    @alegra_contact = alegra_client.get_contact_by_rut(@document.rut)
    create_document if @alegra_contact
  end

  private

  def create_document
    if @document.document_type == :sale
      alegra_document = alegra_client.create_document(alegra_document_hash)
    else
      alegra_document = alegra_client.create_third_party_document(alegra_document_hash)
    end

    update_document_alegra_id(alegra_document)
    alegra_document
  end

  def alegra_document_hash
    hash = {
      id_client: @alegra_contact[:id].to_i,
      bill_number: @document.legal_id,
      bill_date: @document.date,
      bill_due_date: @document.date,
      price: @document.amount
    }

    hash = hash.merge(category_id: 12) if @document.document_type == :buy

    hash
  end

  def update_document_alegra_id(alegra_document)
    if alegra_document[:id]
      @document.update_columns(alegra_id: alegra_document[:id], alegra_status: :synced)
    else
      @document.update_columns(alegra_status: :error)
    end
  end

  def alegra_client
    @alegra_client ||= AlegraClient.new
  end
end
