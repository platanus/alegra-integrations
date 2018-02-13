class AlegraClient
  def create_document(alegra_document)
    response = post('invoices', alegra_document)
    JSON.parse(response)
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
