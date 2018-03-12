class AlegraClient
  # document_hash = {
  #   id_client: "Client_Name",
  #   observations: "Observations",
  #   bill_number: "Bill_Numbre_As_String",
  #   bill_date: "dd/mm/aaaa" or nil for today,
  #   bill_due_date: "dd/mm/aaaa" or nil for today,
  #   id_category: "One_Existing_Category",
  #   price: "Price_As_String"
  # }
  def create_document(document_hash)
    response = post('invoices', alegra_document(document_hash))
    JSON.parse(response)
  end

  def alegra_document(document_hash)
    {
      "date": date_formated_sale(document_hash["bill_date"]),
      "dueDate": date_formated_sale(document_hash["bill_due_date"]),
      "client": document_hash["id_client"].to_i, #REVISAR: ES POR NOMBRE
      "numberTemplate": { "id": 1, "number": document_hash["bill_number"] },
      "items": [
        {
          "id": 1, #Revisar
          "price": document_hash["price"],
          "quantity": 1
        }
      ]
    }
  end

  def date_formated_sale(date)
    date_arr = date.split("/")
    "#{date_arr[2]}-#{date_arr[1]}-#{date_arr[0]}"
  end

  def create_third_party_document(document_hash) #Eliminar HARCODEO
    document_hash = {
      "id_client" => 2,
      "client_name" => "Cliente",
      "observations" => "ObservationsR",
      "bill_number" => 7.to_s,
      "bill_date" => "25/02/2018",
      "bill_due_date" => nil,
      "id_category" => "Legales",
      "price" => "4000"
    }
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
end

# Docs JSON
# {
#   "href": "https://api.bsale.cl/v1/documents/382.json",
#   "id": 382,
#   "emissionDate": 1463540400,
#   "expirationDate": 1464663600,
#   "generationDate": 1463593575,
#   "number": 1,
#   "totalAmount": 14280.0,
#   "netAmount": 12000.0,
#   "taxAmount": 2280.0,
#   "exemptAmount": 0,
#   "exportTotalAmount": 0,
#   "exportNetAmount": 0,
#   "exportTaxAmount": 0,
#   "exportExemptAmount": 0,
#   "commissionRate": 0,
#   "commissionNetAmount": 0,
#   "commissionTaxAmount": 0,
#   "commissionTotalAmount": 0,
#   "percentageTaxWithheld": 0,
#   "purchaseTaxAmount": 0,
#   "purchaseTotalAmount": 0,
#   "urlTimbre": null,
#   "ted": null,
#   "urlPublicView": "http://app2.bsale.cl/view/2/a2d9b4da5128?sfd=99",
#   "urlPdf": "http://app2.bsale.cl/view/2/a2d9b4da5128.pdf?sfd=99",
#   "urlPublicViewOriginal": "http://app2.bsale.cl/view/2/a2d9b4da5128",
#   "urlPdfOriginal": "http://app2.bsale.cl/view/2/a2d9b4da5128.pdf",
#   "token": "a2d9b4da5128",
#   "state": 0,
#   "userId": 2,
#   "urlXml": null,
#   "address": null,
#   "municipality": null,
#   "city": null,
#   "informedSii": 1,
#   "responseMsgSii": null,
#   "document_type": {
#     "href": "https://api.bsale.cl/v1/document_types/1.json",
#     "id": "1"
#   },
#   "client": {
#     "href": "https://api.bsale.cl/v1/clients/7.json",
#     "id": "7"
#   },
#   "office": {
#     "href": "https://api.bsale.cl/v1/offices/2.json",
#     "id": "2"
#   },
#   "user": {
#     "href": "https://api.bsale.cl/v1/users/2.json",
#     "id": "2"
#   },
#   "references": {
#     "href": "https://api.bsale.cl/v1/documents/382/references.json"
#   },
#   "document_taxes": {
#     "href": "https://api.bsale.cl/v1/documents/382/document_taxes.json"
#   },
#   "details": {
#     "href": "https://api.bsale.cl/v1/documents/382/details.json"
#   },
#  "sellers": {
#     "href": "https://api.bsale.cl/v1/documents/382/sellers.json"
#  }
# }
# Terceros JSON
# {
#   "href": "https://api.bsale.cl/v1/third_party_documents/38.json",
#   "id": 38,
#   "codeSii": "34",
#   "emissionDate": 1330657200,
#   "number": 1179981,
#   "clientCode": "89862200-2",
#   "clientActivity": "LAN AIRLINES S.A.",
#   "exemptAmount": 66488.0,
#   "netAmount": 66488.0,
#   "iva": 19.0,
#   "ivaAmount": 0.0,
#   "ivaOutOfTimeAmount": 0.0,
#   "specificTaxCode": null,
#   "specificTaxAmount": "0",
#   "additionalTaxAmount": null,
#   "ivaNotRecoverableAmount": 0.0,
#   "totalAmount": 66488.0,
#   "bookType": "compra",
#   "reportedSii": 0,
#   "thirdSii": 0,
#   "month": 4,
#   "year": 2012,
#   "specificTaxRate": null,
#   "canceled": 0,
#   "ivaAmountWithheld": 0.0,
#   "addBook": 1,
#   "urlPdf": null,
#   "urlXml": null,
#   "fixedAssetAmount": 0.0,
#   "liquidationCode": null,
#   "commissionTotalNetAmount": 0,
#   "commissionTotalExemptAmount": 0,
#   "commissionTotalIvaAmount": 0,
#   "docsCount": 0
# }
