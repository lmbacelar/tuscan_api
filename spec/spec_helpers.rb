module SpecHelpers
  def json_response
    JSON.parse last_response.body, symbolize_names: true
  end

  def response_key k
    json_response.fetch k
  end
end
