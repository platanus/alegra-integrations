class SendDocumentToAlegra < PowerTypes::Command.new(:document)
  def perform
    @alegra_contact = alegra_client.get_contact_by_rut(bsale_contact["code"])
    create_document if @alegra_contact
  end

  private

  def create_document
    response = alegra_client.create_document(alegra_document)
    if response["id"]
      @document.update_columns(alegra_id: response["id"].to_i, alegra_status: :synced)
    else
      @document.update_columns(alegra_status: :error)
    end
    response
  end

  def alegra_document
    emission_date = Time.at(@document.bsale_info["emissionDate"]).to_date
    due_date = Time.at(@document.bsale_info["expirationDate"]).to_date
    {
      "date": date_formated(emission_date),
      "dueDate": date_formated(due_date),
      "client": @alegra_contact["id"].to_i,
      "items": [
        {
          "id": 1,
          "price": @document.bsale_info["totalAmount"],
          "quantity": 1
        }
      ]
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

  def bsale_contact
    url_contact = @document.url_contact_bsale
    @bsale_contact ||= BsaleClient.new.get_bsale_object(url_contact) if url_contact
  end
end
