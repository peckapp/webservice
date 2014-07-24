### PECK COMMAND LINE INTERFACE ###

# a stand-alone command line interface for inteacting with the rails application for testing purposes
# not a part of the rails framework, runs as a stand-alone

require 'restclient'
require 'json'
require 'active_support/core_ext/hash'

class PeckCLI

  PECK_URL = 'loki.peckapp.com'
  PECK_PORT = 3500

  def initialize
    create_users
    @auth_params = { api_key: @user.api_key }
  end

  def create_user
    response_str = RestClient.post(self.paramsURL('/api/users',{}),nil)
    response = JSON.parse(response_str)
    user = User.new response["user"]
  end

  def self.verify_response(response)
    # test for 200 OK, handle others appropriately
  end

  # creates a uri with the specified path and params
  def self.paramsURL(path, params_hash)
    query_str = params_hash.to_query
    URI::HTTP.build({host: PECK_URL, port: PECK_PORT, path: path, query: query_str})
  end

end

class User
  def initialize(hash)
    hash.each do |key, val|
      instance_variable_set(key,val)
    end
    # more concise syntax, pretty neat
    # hash.each &method(:instance_variable_set)
  end

  attr_accessor :first_name
  attr_accessor :last_name
  attr_accessor :email
  attr_accessor :password
  attr_accessor :institution_id
  attr_accessor :user_id
  attr_accessor :api_key
  attr_accessor :authentication_token
end

# Only run the following code when this file is the main file being run
# instead of having been required or loaded by another file
if __FILE__==$0
  # Find the parent directory of this file and add it to the front
  # of the list of locations to look in when using require
  $:.unshift File.expand_path("../../", __FILE__)

  cli = PeckCLI.new



end
