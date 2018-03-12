class SendDocumentToAlegra < PowerTypes::Command.new(:document)
  def perform
    @alegra_contact = alegra_client.get_contact_by_rut(@document.rut)
    create_document if @alegra_contact
  end

  private

  def create_document
    alegra_document = alegra_client.create_document(alegra_document_hash)

    if alegra_document[:id]
      @document.update_columns(alegra_id: alegra_document[:id], alegra_status: :synced)
    else
      @document.update_columns(alegra_status: :error)
    end

    alegra_document
  end

  def alegra_document_hash
    {
      id_client: @alegra_contact[:id].to_i,
      bill_number: @document.legal_id,
      bill_date: @document.date,
      bill_due_date: @document.date,
      price: @document.amount
    }
  end

  def date_formated(date)
    month = date.month.to_s.length == 1 ? "0#{date.month}" : date.month
    day = date.day.to_s.length == 1 ? "0#{date.day}" : date.day
    "#{date.year}-#{month}-#{day}"
  end

  def alegra_client
    @alegra_client ||= AlegraClient.new
  end
end
