require 'rest-client'
require 'json'

class Jet::Client::Files

  FILE_TYPES = {
    variation: 'Variation',
    returns_exception: 'ReturnsException',
    shipping_exception: 'ShippingException',
    archive: 'Archive',
    relationship: 'Relationship',
    price: 'Price',
    inventory: 'Inventory',
    merchant_skus: 'MerchantSKUs',
  }

  def initialize(client)
    @client = client
  end

  def get_upload_token
    headers = @client.token
    response = RestClient.get("#{Jet::Client::API_URL}/files/uploadToken", headers)
    JSON.parse(response.body) if response.code == 200
  end

  def upload_file(url, file_path)
    headers = {"x-ms-blob-type" => "BlockBlob"}
    str = StringIO.new()
    gz = Zlib::GzipWriter.new(str)
    gz.write File.read(file_path)
    gz.close
  
    response = RestClient.put url, str.string, headers
    JSON.parse(response.body) if response.code == 200
  end

  def get_files
    headers = @client.token
    response = RestClient.get("#{Jet::Client::API_URL}/files", headers)
    JSON.parse(response.body) if response.code == 200
  end

  def get_file_by_id(jet_file_id)
    headers = @client.token
    response = RestClient.get("#{Jet::Client::API_URL}/files/#{jet_file_id}", headers)
    JSON.parse(response.body) if response.code == 200
  end

  def get_file_errors(url)
    headers = @client.token
    response = RestClient.get(url, headers)
    JSON.parse(response.body) if response.code == 200
  end

  def notify_uploaded(url, file_type, file_name)
    headers = @client.token
    query_file_type = FILE_TYPES[file_type]
    body = {url: url, file_type: query_file_type, file_name: file_name}
    response = RestClient.post("#{Jet::Client::API_URL}/files/uploaded", body.to_json, headers)
    JSON.parse(response.body) if response.code == 200
  end
end
