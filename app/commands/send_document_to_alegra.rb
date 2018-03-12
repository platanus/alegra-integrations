class SendDocumentToAlegra < PowerTypes::Command.new(:document)
  def perform
    @alegra_contact = alegra_client.get_contact_by_rut(@document.rut)
    create_document if @alegra_contact
  end

  private

  def create_document
    response = nil
    if @document.document_type == "sale"
      response = alegra_client.create_document(document_hash)
    elsif @document.document_type == "buy"
      response = alegra_client.create_third_party_document(document_hash)
    end
    if response["id"]
      @document.update_columns(alegra_id: response["id"].to_i, alegra_status: :synced)
    else
      @document.update_columns(alegra_status: :error)
    end
    response
  end

  def document_hash
    emission_date = Time.at(@document.bsale_info["emissionDate"]).to_date
    due_date = get_due_date
    doc_hash = {
      "id_client" => @alegra_contact["id"],
      "bill_number" => @document.legal_id,
      "bill_date" => date_formated(emission_date),
      "bill_due_date" => date_formated(due_date),
      "price" => @document.bsale_info["totalAmount"].to_s
    }
    if @document.document_type == "buy"  #FALTA
      doc_hash["client_name"] = @alegra_contact["client_name"]
      doc_hash["observations"] = "ObservationsR"
      doc_hash["id_category"] = ""
    end
    doc_hash
  end

  def get_due_date
    if @document.document_type == "sale"
      Time.at(@document.bsale_info["expirationDate"]).to_date
    elsif @document.document_type == "buy"
      Time.now.to_date
    end
  end

  def date_formated(date)
    month = date.month.to_s.length == 1 ? "0#{date.month}" : date.month
    day = date.day.to_s.length == 1 ? "0#{date.day}" : date.day
    "#{day}/#{month}/#{date.year}"
  end

  def alegra_client
    @alegra_client ||= AlegraClient.new
  end
end
