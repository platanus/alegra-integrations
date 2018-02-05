class BsaleClient
  require 'net/http'
  require 'openssl'
  require 'json'

  def get_documents
    url = 'https://api.bsale.cl/v1/documents.json'
    http, request = config_request(url, 'get')
    response = http.request(request)
    JSON.parse(response.body)["items"]
  end

  def get_bsale_object(url)
    http, request = config_request(url, 'get')
    response = http.request(request)
    JSON.parse(response.body)
  end

  private

  def config_request(url, verb)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri) if verb == 'post'
    request = Net::HTTP::Get.new(uri.request_uri) if verb == 'get'
    request['Content-Type'] = 'application/json'
    request['access_token'] = ENV['BSALE_ACCESS_TOKEN']
    [http, request]
  end
end
