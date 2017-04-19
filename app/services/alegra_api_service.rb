class AlegraApiService < PowerTypes::Service.new()
  API_TOKEN = ENV['ALEGRA_TOKEN']
  API_USER = ENV['ALEGRA_USER']
  BASE_URL = "https://app.alegra.com/api/v1"

  def get(endpoint)
    response = RestClient.get url(endpoint), auth_json
    JSON.parse(response.body)
  end

  def post(endpoint, params)
    begin
      RestClient.post url(endpoint), params.to_json, auth_json
    rescue RestClient::ExceptionWithResponse => e
      p e.response.body
    end

  end

  private

  def url(endpoint)
    "#{BASE_URL}/#{endpoint}"
  end

  def auth_json
    text_to_encode = "#{API_USER}:#{API_TOKEN}"

    {
      Authorization: "Basic " + Base64.encode64(text_to_encode)
    }
  end
end
