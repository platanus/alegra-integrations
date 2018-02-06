class SendDocumentToAlegra < PowerTypes::Command.new(:document)
  def perform
    @alegra_contact = AlegraClient.new.find_or_create_contact(bsale_contact) if bsale_contact
    @alegra_contact && @alegra_contact["id"] ? create_document : nil
  end

  private

  def create_document
    response = JSON.parse(AlegraClient.new.post('invoices', alegra_document))
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

  def bsale_contact
    url_contact = @document.url_contact_bsale
    @bsale_contact ||= BsaleClient.new.get_bsale_object(url_contact) if url_contact
  end
end
