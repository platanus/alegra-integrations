class AlegraClient
  def create_document(alegra_document)
    response = post('invoices', alegra_document)
    if response && response.code == 201
      @document.update(alegra_status: :synced)
    end
    response
  end

  def find_or_create_client(bsale_client)
    @bsale_client = bsale_client
    alegra_api_service = AlegraApiService.new
    endpoint = "contacts/?name=#{@bsale_client['firstName']} #{@bsale_client['lastName']}"
    response = alegra_api_service.get(endpoint)
    response.length.positive? ? response.first : create_client(alegra_client)
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

  def create_client(alegra_client)
    alegra_api_service = AlegraApiService.new
    response = alegra_api_service.post('contacts', alegra_client)
    response.try(:code) == 201 ? JSON.parse(response.body) : response
  end

  def alegra_client
    {
      "name": "#{@bsale_client['firstName']} #{@bsale_client['lastName']}",
      "email": @bsale_client["email"],
      "type": ["client"],
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
