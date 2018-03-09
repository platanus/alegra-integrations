class AlegraClient
  # document_hash attributes:
  #
  # id_client:      "Client_Name",
  # bill_number:    "Bill_Numbre_As_String",
  # bill_date:      "dd/mm/aaaa" or nil for today,
  # bill_due_date:  "dd/mm/aaaa" or nil for today,
  # price:          20000
  #
  def create_document(document_hash)
    response = post('invoices', alegra_document_payload(document_hash))
    JSON.parse(response)
  end

  # document_hash attributes:
  #
  # id_client:      "Client_Name",
  # observations:   "Observations",
  # bill_number:    "Bill_Numbre_As_String",
  # bill_date:      "dd/mm/aaaa" or nil for today,
  # bill_due_date:  "dd/mm/aaaa" or nil for today,
  # id_category:    "One_Existing_Category",
  # price:          "Price_As_String"
  #
  def create_third_party_document(document_hash)
    CreateThirdPartyDocument.for(document_hash: document_hash)
  end

  def create_contact(alegra_contact)
    response = post('contacts', alegra_contact)
    JSON.parse(response)
  end

  def get_contact_by_rut(rut)
    rut_cleaned = rut.gsub(/[^\d\-]/, '')

    contacts = get("contacts/?identification=#{rut}")
    contacts = get("contacts/?identification=#{rut_cleaned}") if contacts.empty?

    contacts.first
  end

  def get(endpoint)
    response = RestClient.get url(endpoint), auth_json
    JSON.parse(response.body)
  end

  def post(endpoint, params)
    RestClient.post url(endpoint), params.to_json, auth_json
  rescue RestClient::ExceptionWithResponse => e
    p e.response.body
  end

  private

  def url(endpoint)
    "https://app.alegra.com/api/v1/#{endpoint}"
  end

  def auth_json
    text_to_encode = "#{ENV['ALEGRA_USER']}:#{ENV['ALEGRA_TOKEN']}"

    {
      Authorization: "Basic " + Base64.encode64(text_to_encode)
    }
  end

  def alegra_document_payload(document_hash)
    {
      "date": document_hash[:bill_date].strftime("%F"),
      "dueDate": document_hash[:bill_due_date].strftime("%F"),
      "client": document_hash[:id_client].to_i,
      "numberTemplate": { "id": 1, "number": document_hash[:bill_number] },
      "items": [
        {
          "id": 1,
          "price": document_hash[:price],
          "quantity": 1
        }
      ]
    }
  end
end
