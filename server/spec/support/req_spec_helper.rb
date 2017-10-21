# spec/support/request_spec_helper
module ReqSpecHelper
  def json
    JSON.parse(response.body)
  end
end
