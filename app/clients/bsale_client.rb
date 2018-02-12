class BsaleClient
  require 'net/http'
  require 'openssl'
  require 'json'

  def get_documents
    exempt_invoices = make_document_request(5)
    electronic_invoices = make_document_request(15)
    exempt_invoices + electronic_invoices
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

  def make_document_request(document_type_id)
    url = "https://api.bsale.cl/v1/documents.json?documenttypeid=#{document_type_id}"
    http, request = config_request(url, 'get')
    response = http.request(request)
    JSON.parse(response.body)["items"]
  end
end
