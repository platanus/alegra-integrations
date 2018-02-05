class AlegraClient
  def find_or_create_client(bsale_client)
    @bsale_client = bsale_client
    alegra_api_service = AlegraApiService.new
    endpoint = "contacts/?name=#{@bsale_client['firstName']} #{@bsale_client['lastName']}"
    response = alegra_api_service.get(endpoint)
    response.length.positive? ? response.first : create_client(alegra_client)
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
      "phonePrimary": @bsale_client["phone"]
    }
  end
end
