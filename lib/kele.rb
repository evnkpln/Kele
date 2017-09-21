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

  def get_messages(page = nil)
    url = "https://www.bloc.io/api/v1/message_threads"
    if page
      values = {
        "page": page
      }
    else
      values = {}
    end
    response = self.class.get(url, {headers: {"authorization" => @auth_token}, query: values})
    JSON.parse(response.body)
  end

  def create_message(email, recipient, subject, body, thread = nil )
    url = "https://www.bloc.io/api/v1/messages"
    values = {
      "sender": email,
      "recipient_id": recipient,
      "stripped-text": body,
      "subject": subject,
    }
    if thread
      values["token"] = thread
    end
    response = self.class.post(url, {headers: {"authorization" => @auth_token}, query: values})
    response
  end

end
