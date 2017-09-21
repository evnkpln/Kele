require 'httparty'
require 'json'
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
    @auth_token
  end

  def get_me()
    response = self.class.get('https://www.bloc.io/api/v1/users/me', headers: { "authorization" => @auth_token })
    puts JSON.parse(response.body)
  end
end
