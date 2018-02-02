class SendDocumentToAlegra < PowerTypes::Command.new(:document)
  def perform
    @alegra_client = AlegraClient.new.find_or_create_client(bsale_client)
    @alegra_client && @alegra_client["id"] ? create_document : nil
  end

  private

  def create_document
    alegra_api_service = AlegraApiService.new
    response = JSON.parse(alegra_api_service.post('invoices', alegra_document))
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
      "client": @alegra_client["id"].to_i,
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

  def bsale_client
    @bsale_client ||= BsaleClient.new.get_client(@document.url_client)
  end
end
