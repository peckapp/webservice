### PECK COMMAND LINE INTERFACE ###

# a stand-alone command line interface for inteacting with the rails application for testing purposes
# not a part of the rails framework, runs as a stand-alone

require 'restclient'
require 'json'
require 'commander' # command line interface
require 'active_support/core_ext/hash'

class PeckClient

  PECK_URL = 'loki.peckapp.com'
  PECK_PORT = 3500

  def initialize
    @user = create_user
    puts "Creates Peck Client with user: #{@user}"
    @auth_params = { api_key: @user.api_key }


  end

  def run_all_queries
    # runs all the possible tests in this class
  end

  def create_user
    response_str = RestClient.post(paramsURL('/api/users',{}),nil)
    verify_response(response_str)
    response = JSON.parse(response_str)
    return User.new(response["user"])
  end

  def auth_block
    return {user_id: @user.id, api_key: @user.api_key, institution_id: @user.institution_id, authentication_token: @user.authentication_token}
  end

  def destroy_user
    response_str = RestClient.delete(paramsURL("/api/users/#{@user.id}",{authentication: auth_block}))
    verify_response(response_str)
    response = JSON.parse(response_str)
    puts response
  end

  def verify_response(response)
    case response.code
    when (200..299)
      puts "sucessful response with code #{response.code}"
      return true
    when (300..399)
      puts "sucessful change with code #{response.code}"
      return true
    when 401
      puts "response unauthorized with 401"
    when 404
      puts "response not found with 404"
    when 500
      puts "response indicates internal server error with 500"
    when 502
      puts "response indicates Bad Gateway with 502"
    else
      puts "non specified response code #{response.code}"
    end
    false
  end

  # creates a uri with the specified path and params
  def paramsURL(path, params_hash)
    query_str = params_hash.to_query
    uri_http = URI::HTTP.build({host: PECK_URL, port: PECK_PORT, path: path, query: query_str})
    return uri_http.to_s
  end

end

class User

  attr_accessor :first_name
  attr_accessor :last_name
  attr_accessor :email
  attr_accessor :password
  attr_accessor :institution_id
  attr_accessor :id
  attr_accessor :api_key
  attr_accessor :authentication_token

  def initialize(hash)
    hash.each do |key, val|
      instance_variable_set("@#{key}",val)
    end
    # more concise syntax, pretty neat
    # hash.each &method(:instance_variable_set)
  end

  def to_s
    "first_name: #{@first_name}, last_name: #{@last_name},"\
    "email: #{@email}, password: #{@password},"\
    "institution_id: #{@institution_id}, id: #{@id},"\
    "api_key: #{@api_key}, authentication_token: #{@authentication_token}"
  end
end

# Only run the following code when this file is the main file being run
# instead of having been required or loaded by another file
if __FILE__==$0
  # Find the parent directory of this file and add it to the front
  # of the list of locations to look in when using require
  $:.unshift File.expand_path("../../", __FILE__)

  cli = PeckClient.new

  # command loop
  begin

  rescue InterruptException
    puts "cleaning up and exiting Peck Client interface"
  end

  cli.destroy_user

end
