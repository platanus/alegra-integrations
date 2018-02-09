class AlegraClient
  def create_document(alegra_document)
    response = post('invoices', alegra_document)
    JSON.parse(response)
  end

  def find_or_create_contact(bsale_contact)
    @bsale_contact = bsale_contact
    endpoint = "contacts/?name=#{@bsale_contact['firstName']} #{@bsale_contact['lastName']}"
    response = get(endpoint)
    response.length.positive? ? response.first : create_contact
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

  def create_contact
    response = post('contacts', alegra_contact)
    response.try(:code) == 201 ? JSON.parse(response.body) : response
  end

  def alegra_contact
    {
      "name": "#{@bsale_contact['firstName']} #{@bsale_contact['lastName']}",
      "email": @bsale_contact["email"],
      "type": ["client"],
      "phonePrimary": @bsale_contact["phone"]
    }
  end

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
