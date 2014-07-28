#!/usr/bin/env ruby
### PECK COMMAND LINE INTERFACE ###

# a stand-alone command line interface for inteacting with the rails application for testing purposes
# not a part of the rails framework, runs as a stand-alone

require 'restclient'
require 'json'
require 'thor' # command line interface
require 'active_support/core_ext/hash'

class PeckClient < Thor

  PECK_URL = 'loki.peckapp.com'
  PECK_PORT = 3500

  # requires these parameters as part of thor superclass
  def initialize(a,b,c)
    super(a,b,c)

    create_user_action
  end

  desc "run_all", "Runs all the possible queries and to test all functionality"
  def run_all
    # runs all the possible tests in this class
    puts "running all commands"

    get_events
    get_explore

    destroy_user_action
  end

  desc "get_events", "Retreives all the simple events from the server"
  def get_events
    get_events_action
    destroy_user_action
  end

  desc "get_explore", "Retreives the explore feed from the server"
  def get_explore
    get_explore_action
    destroy_user_action
  end

  no_commands {

    def get_events_action
      response = RestClient.get(paramsURL('/api/simple_events'))
      verify_response("get_events",response)

      events = JSON.parse(response)["simple_events"]
      puts "retreived #{events.length} simple events from the server"
    end

    def get_explore_action
      response = RestClient.get(paramsURL('/api/explore'))
      verify_response("get_explore",response)

      items = JSON.parse(response)["explore"]
      puts "retreived #{items.length} explore items from the server"
    end

    def create_user_action
      response_str = RestClient.post(paramsURL('/api/users'),nil)
      verify_response("create_user",response_str)
      response = JSON.parse(response_str)
      @user = User.new(response["user"])
      puts "Created Peck Client with user: #{@user}"
    end

    def destroy_user_action
      response_str = RestClient.delete(paramsURL("/api/users/#{@user.id}",{authentication: auth_block}))
      verify_response("destroy_user",response_str)
      response = JSON.parse(response_str)
    end

    def auth_block
      return {user_id: @user.id, api_key: @user.api_key, institution_id: @user.institution_id, authentication_token: @user.authentication_token}
    end

    def verify_response(action,response)
      case response.code
      when (200..299)
        puts "#{action} sucessful response with code #{response.code}"
        return true
      when (300..399)
        puts "#{action} sucessful change with code #{response.code}"
        return true
      when 401
        puts "#{action} response unauthorized with 401"
      when 404
        puts "#{action} response not found with 404"
      when 500
        puts "#{action} response indicates internal server error with 500"
      when 502
        puts "#{action} response indicates Bad Gateway with 502"
      else
        puts "#{action} non-specified response code: #{response.code}"
      end
      false
    end

    # creates a uri with the specified path and params, automatically adding auth_block to params
    def paramsURL(path, params_hash={})
      if @user
        params_hash[:authentication] = auth_block
      end
      query_str = params_hash.to_query
      uri_http = URI::HTTP.build({host: PECK_URL, port: PECK_PORT, path: path, query: query_str})
      return uri_http.to_s
    end

  }

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

PeckClient.start(ARGV)

# Only run the following code when this file is the main file being run
# instead of having been required or loaded by another file
# if __FILE__==$0
#   # Find the parent directory of this file and add it to the front
#   # of the list of locations to look in when using require
#   $:.unshift File.expand_path("../../", __FILE__)
#
#   cli = PeckClient.new
#
#   # command loop
#   begin
#
#   rescue InterruptException
#     puts "cleaning up and exiting Peck Client interface"
#   end
#
#   cli.destroy_user
#
# end
