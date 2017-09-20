require 'httparty'
class Kele
  include HTTParty

  def initialize(username,password)
    @base_url = "https:/www.bloc.io/api/v1"

    values = {
      "email": username,
      "password": password
    }

    response = self.class.post('https://www.bloc.io/api/v1/sessions', query: values)
    if response['auth_token']
      @auth_token = response['auth_token']
    else
      raise response['message']
    end
  end
  def token()
    @auth_code
  end
end
