require 'httparty'
require 'json'
require_relative 'roadmap.rb'
class Kele
  include HTTParty
  include Roadmap

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
    response = self.class.get('https://www.bloc.io/api/v1/users/me', headers: { "authorization": @auth_token })
    JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    url = "https://www.bloc.io/api/v1/mentors/#{mentor_id}/student_availability"
    response = self.class.get(url, headers: {"authorization" => @auth_token})
    JSON.parse(response.body)
  end

end
